import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/domain/models/app_settings.dart';
import 'package:label_pro_client/domain/repository/dataset_repository.dart';
import 'package:label_pro_client/domain/repository/settings_repository.dart';
import 'package:label_pro_client/features/settings/bloc/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;
  final DatasetRepository _datasetRepository;

  final TextEditingController serverAddressController = TextEditingController();
  final TextEditingController serverPortController = TextEditingController();
  final TextEditingController datasetIdController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SettingsCubit({
    required DatasetRepository datasetRepository,
    required SettingsRepository settingsRepository,
  })  : _datasetRepository = datasetRepository,
        _settingsRepository = settingsRepository,
        super(SettingsState.initial()) {
    _init();
  }

  @override
  Future<void> close() async {
    await super.close();
    serverAddressController.dispose();
    serverPortController.dispose();
    datasetIdController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  Future<void> _init() async {
    final settings = await _settingsRepository.readSettings();
    emit(
      state.copyWith(
        appSettings: settings,
        serverAvailable: () => null,
      ),
    );
    serverAddressController.text = settings.serverAddress;
    serverPortController.text = settings.servicePort.toString();
    datasetIdController.text = settings.datasetId.toString();
    usernameController.text = settings.username;
    passwordController.text = settings.password;
  }

  Future<void> testSeverConfig({
    required String serverIp,
    required int port,
    required int datasetId,
  }) async {
    emit(
      state.copyWith(
        serverTestInProgress: true,
      ),
    );

    final newSettings = state.appSettings.copyWith(
      serverAddress: serverIp,
      datasetId: datasetId,
      servicePort: port,
    );

    serverAddressController.text = newSettings.serverAddress;
    serverPortController.text = newSettings.servicePort.toString();
    datasetIdController.text = newSettings.datasetId.toString();

    final hasConnection = await _datasetRepository.checkDatasetConnection(newSettings.datasetId);

    emit(
      state.copyWith(
        appSettings: newSettings,
        serverAvailable: () => hasConnection,
        serverTestInProgress: false,
      ),
    );
    await _settingsRepository.updateSettings(
      newSettings,
    );
  }

  Future<void> signIn() async {
    try {
      emit(state.copyWith(
        authInProgress: true,
        authSucceded: () => null,
      ));
      await _datasetRepository.confirmDatasetAuthentication(
        name: usernameController.text,
        password: passwordController.text,
      );

      emit(
        state.copyWith(
          authInProgress: false,
          authSucceded: () => true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          authInProgress: false,
          authSucceded: () => false,
        ),
      );
    } finally {
      final newSettings = state.appSettings.copyWith(
        username: usernameController.text,
        password: passwordController.text,
      );
      await _settingsRepository.updateSettings(
        newSettings,
      );
      emit(
        state.copyWith(appSettings: newSettings),
      );
    }
  }

  Future<void> updateSettings() async {
    final newSettings = AppSettings(
      serverAddress: serverAddressController.text,
      servicePort: int.parse(serverPortController.text),
      username: usernameController.text,
      password: passwordController.text,
      datasetId: int.parse(datasetIdController.text),
    );

    await _settingsRepository.updateSettings(
      newSettings,
    );
  }
}
