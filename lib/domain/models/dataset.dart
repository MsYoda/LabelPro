import 'package:label_pro_client/domain/models/enums/tagging_task_type.dart';

import 'label.dart';

class Dataset {
  final String id;
  final List<Label> availableLabels;
  final TaggingTaskType tasksType;

  const Dataset({
    required this.id,
    required this.availableLabels,
    required this.tasksType,
  });
}
