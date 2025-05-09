import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:label_pro_client/data/api_core/server/server_address_storage.dart';

import 'access_token_pair.dart';
import 'access_token_storage.dart';

class AccessTokenRefresher {
  final AccessTokenStorage _accessTokenStorage;
  final ServerAddressStorage _serverAddressStorage;
  final Dio _dio;

  const AccessTokenRefresher({
    required AccessTokenStorage accessTokenStorage,
    required ServerAddressStorage serverAddressStorage,
    required Dio dio,
  })  : _dio = dio,
        _serverAddressStorage = serverAddressStorage,
        _accessTokenStorage = accessTokenStorage;

  Future<AccessTokenPair?> refreshTokens() async {
    final AccessTokenPair? tokens = await _accessTokenStorage.readTokens();
    if (tokens != null) {
      final address = await _serverAddressStorage.readAddress();
      final Response<dynamic> response = await _dio.post(
        'http://${address.ip}:${address.port}/api/token/refresh/',
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
