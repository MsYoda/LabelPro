import 'package:label_pro_client/domain/models/app_settings.dart';

import '../models/settings_change.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> readSettings();
  Future<void> updateSettings(AppSettings settings);
  Stream<SettingsChange> watchSettings();
}
