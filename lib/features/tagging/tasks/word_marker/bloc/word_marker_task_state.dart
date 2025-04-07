import 'dart:ui';

import 'package:label_pro_client/domain/models/label.dart';

import '../model/word.dart';

class WordMarkerTaskState {
  final List<Word> words;
  final bool isLoading;
  final List<Label> availableLabels;
  final Map<int, Label> markedWords;
  final Map<int, Color> colors;

  const WordMarkerTaskState({
    required this.words,
    required this.isLoading,
    required this.availableLabels,
    required this.markedWords,
    required this.colors,
  });

  WordMarkerTaskState.initial({
    this.words = const [],
    this.isLoading = false,
    this.availableLabels = const [],
    this.markedWords = const {},
    this.colors = const {},
  });

  WordMarkerTaskState copyWith({
    List<Word>? words,
    bool? isLoading,
    List<Label>? availableLabels,
    Map<int, Label>? markedWords,
    Map<int, Color>? colors,
  }) {
    return WordMarkerTaskState(
      words: words ?? this.words,
      isLoading: isLoading ?? this.isLoading,
      availableLabels: availableLabels ?? this.availableLabels,
      markedWords: markedWords ?? this.markedWords,
      colors: colors ?? this.colors,
    );
  }
}
