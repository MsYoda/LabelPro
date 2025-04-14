import 'package:label_pro_client/domain/models/dataset.dart';

class TaggingState {
  final Dataset? dataset;
  final bool isLoading;

  const TaggingState({
    required this.isLoading,
    this.dataset,
  });

  TaggingState.initial({
    this.isLoading = false,
    this.dataset,
  });

  TaggingState copyWith({
    Dataset? dataset,
    bool? isLoading,
  }) {
    return TaggingState(
      isLoading: isLoading ?? this.isLoading,
      dataset: dataset ?? this.dataset,
    );
  }
}
