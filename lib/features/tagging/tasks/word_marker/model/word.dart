class Word {
  final String data;
  final bool selectable;

  const Word({
    required this.data,
    required this.selectable,
  });

  Word copyWith({
    String? data,
    bool? selectable,
  }) {
    return Word(
      data: data ?? this.data,
      selectable: selectable ?? this.selectable,
    );
  }
}
