import 'package:label_pro_client/domain/models/app_settings.dart';

class SettingsState {
  final AppSettings appSettings;
  final bool hasError;
  final bool serverTestInProgress;
  final bool? serverAvailable;

  const SettingsState({
    required this.appSettings,
    required this.hasError,
    required this.serverTestInProgress,
    required this.serverAvailable,
  });

  const SettingsState.initial({
    this.appSettings = const AppSettings.empty(),
    this.hasError = false,
    this.serverTestInProgress = false,
    this.serverAvailable,
  });

  SettingsState copyWith({
    AppSettings? appSettings,
    bool? hasError,
    bool? serverTestInProgress,
    bool? Function()? serverAvailable,
  }) {
    return SettingsState(
      appSettings: appSettings ?? this.appSettings,
      hasError: hasError ?? this.hasError,
      serverTestInProgress: serverTestInProgress ?? this.serverTestInProgress,
      serverAvailable: serverAvailable != null ? serverAvailable() : this.serverAvailable,
    );
  }
}
