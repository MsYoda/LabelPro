import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/data/api_core/token/access_token_refresher.dart';
import 'package:label_pro_client/data/api_core/token/access_token_storage.dart';
import 'package:label_pro_client/data/providers/label_pro_api_service.dart';
import 'package:label_pro_client/data/providers/shared_preference_service.dart';
import 'package:label_pro_client/domain/exceptions/exceptions.dart';
import 'package:label_pro_client/domain/models/app_settings.dart';
import 'package:label_pro_client/domain/models/dataset.dart';
import 'package:label_pro_client/domain/models/tagging_task.dart';
import 'package:label_pro_client/domain/models/tagging_task_result.dart';
import 'package:label_pro_client/domain/repository/dataset_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../api_core/token/access_token_pair.dart';

class DatasetRepositoryImpl implements DatasetRepository {
  final SharedPreferenceService _preferenceService;
  final AccessTokenStorage _accessTokenStorage;
  final AccessTokenRefresher _accessTokenRefresher;
  final LabelProApiService _apiService;

  DatasetRepositoryImpl({
    required AccessTokenStorage accessTokenStorage,
    required AccessTokenRefresher accessTokenRefresher,
    required SharedPreferenceService preferenceService,
    required LabelProApiService apiService,
  })  : _accessTokenRefresher = accessTokenRefresher,
        _accessTokenStorage = accessTokenStorage,
        _preferenceService = preferenceService,
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

  @override
  Future<void> confirmDatasetAuthentication({
    required String name,
    required String password,
  }) async {
    _accessTokenStorage.removeTokens();
    final tokens = await _apiService.confirmDatasetAuthentication(
      name: name,
      password: password,
    );

    await _accessTokenStorage.writeTokens(tokens);
  }

  @override
  Future<bool> isAuthenticated() async {
    final AccessTokenPair? pair = await _accessTokenStorage.readTokens();
    if (pair == null) {
      return false;
    }

    final bool isExpired = JwtDecoder.isExpired(pair.access);

    if (isExpired) {
      try {
        final AccessTokenPair? newTokens = await _accessTokenRefresher.refreshTokens();
        if (newTokens == null) {
          return false;
        }
      } catch (e) {
        return false;
      }
    }

    return true;
  }
}
