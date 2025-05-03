import 'dart:convert';

import 'package:dio/dio.dart';

import 'access_token_pair.dart';
import 'access_token_storage.dart';

class AccessTokenRefresher {
  final AccessTokenStorage _accessTokenStorage;
  final Dio _dio;

  const AccessTokenRefresher({
    required AccessTokenStorage accessTokenStorage,
    required Dio dio,
  })  : _dio = dio,
        _accessTokenStorage = accessTokenStorage;

  Future<AccessTokenPair?> refreshTokens() async {
    final AccessTokenPair? tokens = await _accessTokenStorage.readTokens();
    if (tokens != null) {
      print(tokens.refresh);
      final Response<dynamic> response = await _dio.post(
        'http://localhost:8080/token/refresh/',
        data: jsonEncode(
          {
            'refresh': tokens.refresh,
          },
        ),
      );
      final pair = AccessTokenPair.fromJson(response.data);
      await _accessTokenStorage.writeTokens(pair);
      return pair;
    }
    return null;
  }
}
