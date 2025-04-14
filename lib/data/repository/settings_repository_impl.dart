import 'package:label_pro_client/domain/models/app_settings.dart';
import 'package:label_pro_client/domain/repository/settings_repository.dart';

import '../providers/shared_preference_service.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferenceService _preferenceService;

  SettingsRepositoryImpl({
    required SharedPreferenceService preferenceService,
  }) : _preferenceService = preferenceService;

  Future<AppSettings> _createAppSettings() async {
    final settings = AppSettings.empty();
    await _preferenceService.writeData(
      'settings',
      settings.toJson(),
    );
    return settings;
  }

  @override
  Future<AppSettings> readSettings() async {
    try {
      final settingsJson = await _preferenceService.readData('settings');
      return AppSettings.fromJson(settingsJson);
    } on Exception {
      return _createAppSettings();
    }
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    await _preferenceService.writeData(
      'settings',
      settings.toJson(),
    );
  }
}
