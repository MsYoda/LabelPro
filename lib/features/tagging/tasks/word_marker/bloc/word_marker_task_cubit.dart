import 'dart:convert';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core_ui/theme/app_colors.dart';
import 'package:label_pro_client/domain/exceptions/exceptions.dart';
import 'package:label_pro_client/domain/models/label.dart';
import 'package:label_pro_client/domain/models/tagging_task_result.dart';
import 'package:label_pro_client/domain/models/task_types/word_tagging_solution_data.dart';
import 'package:label_pro_client/domain/repository/dataset_repository.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/bloc/word_marker_task_state.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/model/word.dart';

class WordMarkerTaskCubit extends Cubit<WordMarkerTaskState> {
  final DatasetRepository _datasetRepository;

  WordMarkerTaskCubit({
    required List<Label> labels,
    required DatasetRepository datasetRepository,
  })  : _datasetRepository = datasetRepository,
        super(
          WordMarkerTaskState.initial(
            availableLabels: labels,
          ),
        ) {
    _init();
  }

  bool _isNotPunctuation(String text) {
    final punctuationRegex = RegExp(r'^[^\p{P}]+$', unicode: true);
    return punctuationRegex.hasMatch(text);
  }

  Future<void> _init() async {
    try {
      emit(
        state.copyWith(
          markedWords: {},
          isLoading: true,
        ),
      );
      final task = await _datasetRepository.getTaggingTask();
      final Map<int, Color> colors = {};
      for (int i = 0; i < state.availableLabels.length; i++) {
        colors[state.availableLabels[i].id] = AppColors.accentColorFromIndex(i);
      }

      emit(
        state.copyWith(
          idInFile: task.idInFile,
          filename: task.filename,
          colors: colors,
          isLoading: false,
          words: task.data
              .split(' ')
              .map(
                (e) => Word(
                  data: e,
                  selectable: _isNotPunctuation(e),
                ),
              )
              .toList(),
        ),
      );
    } on DatasetIsEmpty {
      emit(
        state.copyWith(
          isDatasetEmpty: true,
          isLoading: false,
        ),
      );
    }
  }

  void updateMark({
    required int wordIndex,
    required Label label,
  }) {
    final newMarks = {...state.markedWords};
    newMarks[wordIndex] = label;
    emit(
      state.copyWith(
        markedWords: newMarks,
      ),
    );
  }

  void clearMark({
    required int wordIndex,
  }) {
    final newMarks = {...state.markedWords};
    newMarks.remove(wordIndex);
    emit(
      state.copyWith(
        markedWords: newMarks,
      ),
    );
  }

  Future<void> submitTask() async {
    print(
      jsonEncode(
        WordTaggingSolutionData(
          markedWords: state.markedWords.map(
            (key, value) => MapEntry(key, value.name),
          ),
        ).toJson(),
      ),
    );
    await _datasetRepository.submitTaggingTask(
      TaggingTaskResult(
        filename: state.filename,
        idInFile: state.idInFile,
        datasetId: 2,
        data: WordTaggingSolutionData(
          markedWords: state.markedWords.map(
            (key, value) => MapEntry(key, value.name),
          ),
        ).toJson(),
      ),
    );
    _init();
  }
}
