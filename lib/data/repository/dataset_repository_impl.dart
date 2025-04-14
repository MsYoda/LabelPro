import 'package:dio/dio.dart';
import 'package:label_pro_client/data/providers/label_pro_api_service.dart';
import 'package:label_pro_client/data/providers/shared_preference_service.dart';
import 'package:label_pro_client/domain/exceptions/exceptions.dart';
import 'package:label_pro_client/domain/models/app_settings.dart';
import 'package:label_pro_client/domain/models/dataset.dart';
import 'package:label_pro_client/domain/models/tagging_task.dart';
import 'package:label_pro_client/domain/models/tagging_task_result.dart';
import 'package:label_pro_client/domain/repository/dataset_repository.dart';

class DatasetRepositoryImpl implements DatasetRepository {
  final SharedPreferenceService _preferenceService;
  final LabelProApiService _apiService;

  DatasetRepositoryImpl({
    required SharedPreferenceService preferenceService,
    required LabelProApiService apiService,
  })  : _preferenceService = preferenceService,
        _apiService = apiService;

  @override
  Future<Dataset> getDatasetById(int id) async {
    return _apiService.getDatasetById(id);
  }

  @override
  Future<TaggingTask> getTaggingTask() async {
    try {
      final settings = AppSettings.fromJson(
        await _preferenceService.readData('settings'),
      );
      final result = await _apiService.getTaggingTask(settings.datasetId);
      return result;
    } on DioException catch (e) {
      print(e.response?.statusCode);
      if (e.response!.statusCode.toString() == '404') {
        throw DatasetIsEmpty();
      }
      rethrow;
    }
  }

  @override
  Future<void> submitTaggingTask(TaggingTaskResult result) {
    return _apiService.submitTaggingTask(result);
  }

  @override
  Future<bool> checkDatasetConnection(int datasetId) async {
    try {
      await _apiService.getDatasetById(datasetId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
