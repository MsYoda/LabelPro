import 'package:label_pro_client/domain/models/dataset.dart';
import 'package:label_pro_client/domain/models/enums/tagging_task_type.dart';

class TaggingState {
  final Dataset dataset;

  const TaggingState({
    required this.dataset,
  });

  TaggingState.initial({
    this.dataset = const Dataset(
      id: '',
      availableLabels: [],
      tasksType: TaggingTaskType.boundingBox,
    ),
  });

  TaggingState copyWith({
    Dataset? dataset,
  }) {
    return TaggingState(
      dataset: dataset ?? this.dataset,
    );
  }
}
