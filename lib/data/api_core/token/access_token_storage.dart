import 'dart:convert';

import '../../const/storage_const.dart';
import '../../providers/shared_preference_service.dart';
import 'access_token_pair.dart';

class AccessTokenStorage {
  final SharedPreferenceService _sharedPreferenceService;

  AccessTokenStorage({
    required SharedPreferenceService sharedPreferenceService,
  }) : _sharedPreferenceService = sharedPreferenceService;

  Future<AccessTokenPair?> readTokens() async {
    if (!(await _sharedPreferenceService.containKey(StorageConstants.tokenKey))) return null;
    return AccessTokenPair.fromJson(
      await _sharedPreferenceService.readData(StorageConstants.tokenKey),
    );
  }

  Future<void> writeTokens(AccessTokenPair pair) async {
    await _sharedPreferenceService.writeData(StorageConstants.tokenKey, pair.toJson());
  }

  Future<void> removeTokens() async {
    await _sharedPreferenceService.removeData(StorageConstants.tokenKey);
  }
}
