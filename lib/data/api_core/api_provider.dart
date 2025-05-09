import 'dart:io';

import 'package:dio/dio.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/data/api_core/server/server_address.dart';
import 'package:label_pro_client/data/api_core/server/server_address_storage.dart';
import 'package:label_pro_client/data/api_core/token/access_token_pair.dart';
import 'package:label_pro_client/data/api_core/token/access_token_refresher.dart';
import 'package:label_pro_client/data/api_core/token/access_token_storage.dart';
import 'package:label_pro_client/domain/models/app_settings.dart';

import 'request/api_request.dart';
import 'request/api_request_options.dart';

class ApiProvider {
  final Dio _dio;
  final AccessTokenStorage _accessTokenStorage;
  final AccessTokenRefresher _accessTokenRefresher;
  final ServerAddressStorage _serverAddressStorage;

  ApiProvider({
    required Dio dio,
    required AccessTokenStorage accessTokenStorage,
    required AccessTokenRefresher accessTokenRefresher,
    required ServerAddressStorage serverAddressStorage,
  })  : _dio = dio,
        _accessTokenStorage = accessTokenStorage,
        _accessTokenRefresher = accessTokenRefresher,
        _serverAddressStorage = serverAddressStorage;

  Future<T> parsed<T>({
    required ApiRequest request,
    required T Function(Map<String, dynamic> data) parser,
    ApiRequestOptions options = const ApiRequestOptions(),
  }) async {
    final Map<String, dynamic> data = await _request(
      request: request,
      options: options,
    );
    return parser(data);
  }

  Future<List<T>> parsedList<T>({
    required T Function(Map<String, dynamic> data) parser,
    required ApiRequest request,
    String? key,
    bool skipIfThrow = false,
    ApiRequestOptions options = const ApiRequestOptions(),
  }) async {
    final List<T> result = <T>[];
    final dynamic data = await _request(
      request: request,
      options: options,
    );
    final List<dynamic> dataToParse = key == null ? data : data[key];
    for (final Map<String, dynamic> obj in dataToParse) {
      try {
        result.add(parser(obj));
      } catch (e) {
        if (!skipIfThrow) {
          rethrow;
        }
      }
    }
    return result;
  }

  Future<void> none({
    required ApiRequest request,
    ApiRequestOptions options = const ApiRequestOptions(),
  }) async {
    await _request(
      request: request,
      options: options,
    );
  }

  Future<dynamic> _request({
    required ApiRequest request,
    required ApiRequestOptions options,
    bool didRefreshTokens = false,
  }) async {
    try {
      Map<String, dynamic>? headers = request.headers;
      if (options.useDefaultAuth) {
        final AccessTokenPair? tokens = await _accessTokenStorage.readTokens();
        final ServerAddress address = await _serverAddressStorage.readAddress();
        if (tokens != null) {
          headers ??= <String, dynamic>{};
          headers['Authorization'] = 'Bearer ${tokens.access}';
        }
        print('http://${address.ip}:${address.port}/${request.url}');

        final Response<dynamic> response = await _dio.request(
          'http://${address.ip}:${address.port}/${request.url}',
          data: request.body,
          queryParameters: request.params,
          options: Options(
            method: request.method.key,
            headers: headers,
          ),
        );
        print(response.statusCode);
        return response.data;
      }
    } on DioException catch (e) {
      final bool unauthorized = e.response?.statusCode == HttpStatus.unauthorized;
      final bool canRefresh = options.useDefaultAuth && !didRefreshTokens;
      if (unauthorized && canRefresh) {
        final AccessTokenPair? tokens = await _accessTokenRefresher.refreshTokens();
        if (tokens != null) {
          await _accessTokenStorage.writeTokens(tokens);
          return _request(
            request: request,
            options: options,
            didRefreshTokens: true,
          );
        }
      }
      rethrow;
    }
  }
}
