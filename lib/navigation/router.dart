import 'package:auto_route/auto_route.dart';
import 'package:label_pro_client/navigation/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Dialog,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        CustomRoute(
          page: HomeRoute.page,
          initial: true,
          durationInMilliseconds: 0,
          children: [
            CustomRoute(
              page: TaggingRoute.page,
              initial: true,
              durationInMilliseconds: 0,
              children: [
                CustomRoute(
                  page: BoundingBoxTaskRoute.page,
                  durationInMilliseconds: 0,
                ),
                CustomRoute(
                  page: WordMarkerTaskRoute.page,
                  durationInMilliseconds: 0,
                ),
              ],
            ),
            CustomRoute(
              page: SettingsRoute.page,
              maintainState: false,
              durationInMilliseconds: 0,
            ),
          ],
        ),
      ];
}
