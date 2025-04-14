import 'package:dio/dio.dart';
import 'package:label_pro_client/data/api_core/api_provider.dart';
import 'package:label_pro_client/data/api_core/request/api_request.dart';
import 'package:label_pro_client/data/api_core/request/http_method.dart';
import 'package:label_pro_client/domain/models/dataset.dart';
import 'package:label_pro_client/domain/models/tagging_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/tagging_task_result.dart';

class LabelProApiService {
  final ApiProvider _apiProvider;
  final SharedPreferences _sharedPreferences;

  LabelProApiService({
    required ApiProvider apiProvider,
    required SharedPreferences sharedPreferences,
  })  : _apiProvider = apiProvider,
        _sharedPreferences = sharedPreferences;

  Future<Dataset> getDatasetById(int id) async {
    final dataset = await _apiProvider.parsed(
      request: ApiRequest(
        method: HttpMethod.get,
        url: 'http://localhost:8080/dataset/$id',
      ),
      parser: Dataset.fromJson,
    );
    return dataset;
  }

  Future<TaggingTask> getTaggingTask(int datasetId) async {
    final task = await _apiProvider.parsed(
      request: ApiRequest(
        method: HttpMethod.get,
        url: 'http://localhost:8080/task/',
        params: {
          'dataset_id': datasetId,
        },
      ),
      parser: TaggingTask.fromJson,
    );
    return task;
  }

  Future<void> submitTaggingTask(TaggingTaskResult result) async {
    print(result.data);
    await _apiProvider.none(
      request: ApiRequest(
        method: HttpMethod.post,
        url: 'http://localhost:8080/task/',
        body: FormData.fromMap(
          result.toJson(),
        ),
      ),
    );
  }
}
