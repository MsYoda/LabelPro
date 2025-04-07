import 'package:label_pro_client/domain/models/dataset.dart';
import 'package:label_pro_client/domain/models/enums/tagging_task_type.dart';

class TaggingState {
  final Dataset dataset;
  final bool isLoading;

  const TaggingState({
    required this.isLoading,
    required this.dataset,
  });

  TaggingState.initial({
    this.isLoading = false,
    this.dataset = const Dataset(
      id: 1,
      availableLabels: [],
      tasksType: TaggingTaskType.boundingBox,
      name: '',
    ),
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
