part of 'init_dependencies.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  ///register secure storage
  sl.registerLazySingleton(() => SecureStorageService());

  ///register shared preferences
  final sharedPrefService = SharedPrefService();
  await sharedPrefService.init();
  sl.registerLazySingleton<SharedPrefService>(() => sharedPrefService);

  /// Internet Checker
  sl.registerLazySingleton(() => InternetConnection());

  /// register Connection Checker
  sl.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(sl()),
  );



  ///don't remove this comment

  await NewsInjector.init(); // registers News feature
  await MainInjector.init(); // registers Main feature
}
