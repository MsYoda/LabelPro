import 'dart:convert';

class TaggingTaskResult {
  final String filename;
  final String idInFile;
  final int datasetId;
  final Map<String, dynamic> data;

  const TaggingTaskResult({
    required this.filename,
    required this.idInFile,
    required this.datasetId,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'file_path': filename,
      'id_in_file': idInFile,
      'dataset_id': datasetId,
      'data': jsonEncode(data),
    };
  }
}
