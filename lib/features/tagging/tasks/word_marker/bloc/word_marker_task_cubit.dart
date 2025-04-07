import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core_ui/theme/app_colors.dart';
import 'package:label_pro_client/domain/models/label.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/bloc/word_marker_task_state.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/model/word.dart';

class WordMarkerTaskCubit extends Cubit<WordMarkerTaskState> {
  WordMarkerTaskCubit({
    required List<Label> labels,
  }) : super(
          WordMarkerTaskState.initial(
            availableLabels: labels,
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    final test = [
      'Steve',
      'is',
      'wornderful',
      'person',
      'and',
      'he',
      'know',
      'how',
      'to',
      'implement',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
      'code',
    ];
    final Map<int, Color> colors = {};
    for (int i = 0; i < state.availableLabels.length; i++) {
      colors[state.availableLabels[i].id] = AppColors.accentColorFromIndex(i);
    }

    emit(
      state.copyWith(
        colors: colors,
        words: test
            .map(
              (e) => Word(data: e, selectable: false),
            )
            .toList(),
      ),
    );
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
}
