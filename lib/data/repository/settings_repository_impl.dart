import 'dart:async';

import 'package:label_pro_client/data/api_core/server/server_address.dart';
import 'package:label_pro_client/data/api_core/server/server_address_storage.dart';
import 'package:label_pro_client/domain/models/app_settings.dart';
import 'package:label_pro_client/domain/repository/settings_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/models/settings_change.dart';
import '../providers/shared_preference_service.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferenceService _preferenceService;
  final ServerAddressStorage _serverAddressStorage;
  final StreamController<SettingsChange> _appSettingsController = BehaviorSubject<SettingsChange>();

  SettingsRepositoryImpl({
    required SharedPreferenceService preferenceService,
    required ServerAddressStorage serverAddressStorage,
  })  : _serverAddressStorage = serverAddressStorage,
        _preferenceService = preferenceService {
    _init();
  }

  Future<void> _init() async {
    try {
      final setting = await readSettings();
      _appSettingsController.add(SettingsChange(
        oldData: null,
        newData: setting,
      ));
    } catch (e) {
      // pass
    }
  }

  Future<AppSettings> _createAppSettings() async {
    final settings = AppSettings.empty();
    await _preferenceService.writeData(
      'settings',
      settings.toJson(),
    );
    return settings;
  }

  @override
  Future<AppSettings> readSettings() async {
    try {
      final settingsJson = await _preferenceService.readData('settings');
      return AppSettings.fromJson(settingsJson);
    } on Exception {
      return _createAppSettings();
    }
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    final oldSettings = await readSettings();
    await _preferenceService.writeData(
      'settings',
      settings.toJson(),
    );
    await _serverAddressStorage.writeAddress(
      ServerAddress(
        ip: settings.serverAddress,
        port: settings.servicePort,
      ),
    );
    _appSettingsController.add(
      SettingsChange(
        oldData: oldSettings,
        newData: settings,
      ),
    );
  }

  @override
  Stream<SettingsChange> watchSettings() {
    return _appSettingsController.stream;
  }
}
