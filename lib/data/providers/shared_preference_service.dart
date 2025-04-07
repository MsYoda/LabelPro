import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final SharedPreferences _sharedPreferences;

  SharedPreferenceService({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;
}
