import 'package:label_pro_client/domain/models/app_settings.dart';

class SettingsState {
  final AppSettings appSettings;
  final bool hasError;
  final bool serverTestInProgress;
  final bool? serverAvailable;
  final bool? authSucceded;
  final bool authInProgress;

  const SettingsState({
    required this.authSucceded,
    required this.authInProgress,
    required this.appSettings,
    required this.hasError,
    required this.serverTestInProgress,
    required this.serverAvailable,
  });

  const SettingsState.initial({
    this.appSettings = const AppSettings.empty(),
    this.authInProgress = false,
    this.hasError = false,
    this.serverTestInProgress = false,
    this.serverAvailable,
    this.authSucceded,
  });

  SettingsState copyWith({
    AppSettings? appSettings,
    bool? hasError,
    bool? serverTestInProgress,
    bool? Function()? serverAvailable,
    bool? Function()? authSucceded,
    bool? authInProgress,
  }) {
    return SettingsState(
      appSettings: appSettings ?? this.appSettings,
      hasError: hasError ?? this.hasError,
      serverTestInProgress: serverTestInProgress ?? this.serverTestInProgress,
      serverAvailable: serverAvailable != null ? serverAvailable() : this.serverAvailable,
      authSucceded: authSucceded != null ? authSucceded() : this.authSucceded,
      authInProgress: authInProgress ?? this.authInProgress,
    );
  }
}
