import 'package:auto_route/auto_route.dart';
import 'package:label_pro_client/navigation/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Dialog,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          children: [
            AutoRoute(
              page: TaggingRoute.page,
              initial: true,
              children: [
                AutoRoute(
                  page: BoundingBoxTaskRoute.page,
                  initial: true,
                ),
                AutoRoute(
                  page: WordMarkerTaskRoute.page,
                ),
              ],
            ),
          ],
        ),
      ];
}
