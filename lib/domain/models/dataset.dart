import 'package:label_pro_client/core/utils/string_ext.dart';
import 'package:label_pro_client/domain/models/enums/tagging_task_type.dart';

import 'label.dart';

class Dataset {
  final int id;
  final String name;
  final List<Label> availableLabels;
  final TaggingTaskType tasksType;

  const Dataset({
    required this.id,
    required this.availableLabels,
    required this.tasksType,
    required this.name,
  });

  factory Dataset.fromJson(Map<String, dynamic> json) {
    return Dataset(
      id: json['id'] as int,
      name: json['name'] as String,
      availableLabels: (json['availableLabels'] as List<dynamic>)
          .map((label) => Label.fromJson(label as Map<String, dynamic>))
          .toList(),
      tasksType: TaggingTaskType.values.byName((json['tasksType'] as String).toCamelCase()),
    );
  }
}
