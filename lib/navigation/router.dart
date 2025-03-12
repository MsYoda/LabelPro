import 'package:auto_route/auto_route.dart';
import 'package:label_pro_client/navigation/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Dialog,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(
          page: TaggingRoute.page,
          initial: true,
          children: [
            AutoRoute(
              page: BoundingBoxTaskRoute.page,
            ),
            AutoRoute(
              initial: true,
              page: WordMarkerTaskRoute.page,
            ),
          ],
        ),
      ];
}
