class WordTaggingSolutionData {
  final Map<int, String> markedWords;

  const WordTaggingSolutionData({
    required this.markedWords,
  });

  Map<String, dynamic> toJson() {
    return {
      'words': markedWords.map((key, value) => MapEntry(key.toString(), value)),
    };
  }
}
