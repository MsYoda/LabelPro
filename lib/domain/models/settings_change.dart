import 'app_settings.dart';

class SettingsChange {
  final AppSettings? oldData;
  final AppSettings newData;

  const SettingsChange({
    required this.oldData,
    required this.newData,
  });
}
