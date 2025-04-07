import 'package:label_pro_client/core/utils/string_ext.dart';

import 'enums/tagging_task_type.dart';

class TaggingTask {
  final TaggingTaskType type;
  final String filename;
  final String idInFile;
  final String data;
  final Map<String, dynamic> metadata;

  const TaggingTask({
    required this.type,
    required this.filename,
    required this.idInFile,
    required this.metadata,
    required this.data,
  });

  factory TaggingTask.fromJson(Map<String, dynamic> json) {
    return TaggingTask(
      data: json['data'] as String,
      type: TaggingTaskType.values.byName((json['type'] as String).toCamelCase()),
      filename: json['filename'] as String,
      idInFile: json['idInFile'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
    );
  }
}
