import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/domain/exceptions/exceptions.dart';
import 'package:label_pro_client/domain/models/enums/custom_data_type.dart';
import 'package:label_pro_client/domain/models/enums/custom_input_type.dart';
import 'package:label_pro_client/domain/models/label.dart';
import 'package:label_pro_client/domain/models/tagging_task_result.dart';
import 'package:label_pro_client/domain/models/task_types/custom_solution_data.dart';
import 'package:label_pro_client/domain/repository/dataset_repository.dart';
import 'package:label_pro_client/domain/repository/settings_repository.dart';
import 'package:label_pro_client/features/tagging/tasks/custom/bloc/custom_task_state.dart';

class CustomTaskCubit extends Cubit<CustomTaskState> {
  final DatasetRepository _datasetRepository;

  CustomTaskCubit({
    required List<Label> labels,
    required DatasetRepository datasetRepository,
  })  : _datasetRepository = datasetRepository,
        super(CustomTaskState.initial(availableLabels: labels)) {
    _init();
  }

  Future<void> _init() async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
        ),
      );
      final task = await _datasetRepository.getTaggingTask();

      emit(
        state.copyWith(
          idInFile: task.idInFile,
          filename: task.filename,
          isLoading: false,
          data: task.data,
          inputType: CustomInputType.fromString(
            task.metadata['input_type'],
          ),
          dataType: CustomDataType.fromString(
            task.metadata['data_type'],
          ),
        ),
      );
    } on DatasetIsEmpty {
      emit(
        state.copyWith(
          isDatasetOver: true,
          isLoading: false,
        ),
      );
    }
  }

  void updateSelectedData(List<String> data) {
    emit(
      state.copyWith(
        input: data,
      ),
    );
  }

  Future<void> submitTask() async {
    print(
      jsonEncode(
        CustomSolutionData(
          type: state.inputType,
          result: state.input,
        ).toJson(),
      ),
    );
    final settings = await appLocator<SettingsRepository>().readSettings();
    try {
      await _datasetRepository.submitTaggingTask(
        TaggingTaskResult(
          filename: state.filename,
          idInFile: state.idInFile,
          datasetId: settings.datasetId,
          data: CustomSolutionData(
            type: state.inputType,
            result: state.input,
          ).toJson(),
        ),
      );
      _init();
    } on DatasetIsEmpty {
      emit(state.copyWith(
        isDatasetOver: true,
        isLoading: false,
      ));
    }
  }
}
