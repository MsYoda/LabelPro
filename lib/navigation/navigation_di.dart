import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/navigation/router.dart';

abstract class NavigationDI {
  static void init() {
    appLocator.registerSingleton(
      AppRouter(),
    );
  }
}
