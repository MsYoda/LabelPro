import 'dart:convert';

import 'package:label_pro_client/domain/exceptions/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final SharedPreferences _sharedPreferences;

  SharedPreferenceService({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  Future<void> writeData(String key, Map<String, dynamic> data) async {
    await _sharedPreferences.setString(
      key,
      jsonEncode(data),
    );
  }

  Future<Map<String, dynamic>> readData(String key) async {
    final resultJson = _sharedPreferences.getString(key);
    if (resultJson == null) {
      throw DataNotFound();
    }
    return jsonDecode(resultJson);
  }
}
