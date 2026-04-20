part of 'init_dependencies.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  ///register secure storage
  sl.registerLazySingleton(() => SecureStorageService());

  /// Internet Checker
  sl.registerLazySingleton(() => InternetConnection());

  /// register Connection Checker
  sl.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(sl()),
  );

  /// Api Client
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: ApiEndpoint.newsBaseUrl,
      onLogout: () async {
        await sl<SecureStorageService>().deleteAll();
        await sl<SharedPrefService>().clear();
      },
      getToken: () {
        return sl<SecureStorageService>().read('accessToken');
      },
    ),
  );

  ///don't remove this comment

  await NewsInjector.init(); // registers News feature
}
