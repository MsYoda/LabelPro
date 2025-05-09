import 'package:dio/dio.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/data/api_core/api_provider.dart';
import 'package:label_pro_client/data/api_core/server/server_address_storage.dart';
import 'package:label_pro_client/data/api_core/token/access_token_refresher.dart';
import 'package:label_pro_client/data/api_core/token/access_token_storage.dart';
import 'package:label_pro_client/data/providers/label_pro_api_service.dart';
import 'package:label_pro_client/data/providers/shared_preference_service.dart';
import 'package:label_pro_client/data/repository/dataset_repository_impl.dart';
import 'package:label_pro_client/data/repository/settings_repository_impl.dart';
import 'package:label_pro_client/domain/repository/dataset_repository.dart';
import 'package:label_pro_client/domain/repository/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation/router.dart';

abstract class Di {
  static Future<void> initDependencies() async {
    appLocator.registerSingleton(AppRouter());
    appLocator.registerSingleton<Dio>(Dio());

    final sharedPreferences = await SharedPreferences.getInstance();
    appLocator.registerSingleton<SharedPreferences>(sharedPreferences);

    appLocator.registerSingleton<SharedPreferenceService>(SharedPreferenceService(
      sharedPreferences: appLocator(),
    ));

    appLocator.registerSingleton<ServerAddressStorage>(
      ServerAddressStorage(
        sharedPreferenceService: appLocator(),
      ),
    );
    appLocator.registerSingleton<AccessTokenStorage>(
      AccessTokenStorage(
        sharedPreferenceService: appLocator(),
      ),
    );
    appLocator.registerSingleton<AccessTokenRefresher>(
      AccessTokenRefresher(
        accessTokenStorage: appLocator(),
        serverAddressStorage: appLocator(),
        dio: appLocator(),
      ),
    );

    appLocator.registerSingleton<ApiProvider>(
      ApiProvider(
        dio: appLocator(),
        accessTokenRefresher: appLocator(),
        accessTokenStorage: appLocator(),
        serverAddressStorage: appLocator(),
      ),
    );

    appLocator.registerSingleton<LabelProApiService>(LabelProApiService(
      apiProvider: appLocator(),
      sharedPreferences: appLocator(),
    ));

    appLocator.registerSingleton<DatasetRepository>(
      DatasetRepositoryImpl(
        apiService: appLocator(),
        preferenceService: appLocator(),
        accessTokenStorage: appLocator(),
        accessTokenRefresher: appLocator(),
      ),
    );
    appLocator.registerSingleton<SettingsRepository>(
      SettingsRepositoryImpl(
        preferenceService: appLocator(),
        serverAddressStorage: appLocator(),
      ),
    );
  }
}
