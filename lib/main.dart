import 'package:flutter/material.dart';

import 'core/core.dart';
import 'navigation/navigation_di.dart';
import 'navigation/router.dart';

void main() {
  runApp(const MyApp());
  NavigationDI.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = appLocator<AppRouter>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
      themeMode: ThemeMode.light,
    );
  }
}
