import 'package:label_pro_client/domain/models/tagging_task.dart';
import 'package:label_pro_client/domain/models/tagging_task_result.dart';

import '../models/dataset.dart';

abstract interface class DatasetRepository {
  Future<Dataset> getDatasetById(int id);
  Future<TaggingTask> getTaggingTask();

  Future<void> submitTaggingTask(TaggingTaskResult result) async {}
  Future<bool> checkDatasetConnection(int datasetId);
  Future<void> confirmDatasetAuthentication({
    required String name,
    required String password,
  });
  Future<bool> isAuthenticated();
}
