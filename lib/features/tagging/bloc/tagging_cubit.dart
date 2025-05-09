import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/domain/models/app_settings.dart';
import 'package:label_pro_client/domain/models/dataset.dart';
import 'package:label_pro_client/domain/models/enums/tagging_task_type.dart';
import 'package:label_pro_client/domain/models/settings_change.dart';
import 'package:label_pro_client/domain/repository/dataset_repository.dart';
import 'package:label_pro_client/domain/repository/settings_repository.dart';
import 'package:label_pro_client/features/tagging/bloc/tagging_state.dart';
import 'package:label_pro_client/navigation/router.dart';
import 'package:label_pro_client/navigation/router.gr.dart';

class TaggingCubit extends Cubit<TaggingState> {
  final DatasetRepository _datasetRepository;
  final SettingsRepository _settingsRepository;
  final AppRouter _appRouter;
  StreamSubscription<SettingsChange>? _settingsSubscription;

  TaggingCubit({
    required AppRouter appRouter,
    required SettingsRepository settingsRepository,
    required DatasetRepository datasetRepository,
  })  : _settingsRepository = settingsRepository,
        _datasetRepository = datasetRepository,
        _appRouter = appRouter,
        super(
          TaggingState.initial(),
        ) {
    _settingsSubscription = _settingsRepository.watchSettings().listen(
      (data) async {
        _init();
      },
    );
  }

  Future<void> _init() async {
    try {
      emit(
        state.copyWith(isLoading: true),
      );
      final settings = await _settingsRepository.readSettings();
      final Dataset dataset = await _datasetRepository.getDatasetById(settings.datasetId);
      emit(
        state.copyWith(
          isLoading: false,
          dataset: () => dataset,
        ),
      );
      print('DATASET LOADeD');
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
          dataset: () => null,
          isLoading: false,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    super.close();
    await _settingsSubscription?.cancel();
  }
}
