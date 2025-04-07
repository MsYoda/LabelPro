import 'package:label_pro_client/domain/repository/settings_repository.dart';

import '../providers/shared_preference_service.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferenceService _preferenceService;

  SettingsRepositoryImpl({
    required SharedPreferenceService preferenceService,
  }) : _preferenceService = preferenceService;
}
