import 'package:hive_flutter/hive_flutter.dart';
import '../../core/di/init_dependencies.dart';
import '../../core/network/api_client.dart';
import '../../core/network/connection_checker.dart';
import 'data/datasources/news_local_data_source.dart';
import 'data/datasources/news_remote_data_source.dart';
import 'data/models/article_model_adapter.dart';
import 'data/repositories/news_repository_impl.dart';
import 'domain/repositories/news_repository.dart';
import 'domain/usecases/get_top_headlines_usecase.dart';
import 'domain/usecases/search_news_usecase.dart';
import 'presentation/bloc/news_bloc.dart';

class NewsInjector {
  static Future<void> init() async {
    // ── Local Storage (Hive) ─────────────────────────────────────────────
    if (!Hive.isAdapterRegistered(0)) {
       Hive.registerAdapter(ArticleModelAdapter());
    }

    // ── Data Sources ─────────────────────────────────────────────────────
    sl.registerLazySingleton<NewsRemoteDataSource>(
      () => NewsRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );
    sl.registerLazySingleton<NewsLocalDataSource>(
      () => NewsLocalDataSourceImpl(),
    );

    // ── Repository ───────────────────────────────────────────────────────
    sl.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(
        remoteDataSource: sl<NewsRemoteDataSource>(),
        localDataSource: sl<NewsLocalDataSource>(),
        connectionChecker: sl<ConnectionChecker>(),
      ),
    );

    // ── Use Cases ────────────────────────────────────────────────────────
    sl.registerLazySingleton(
      () => GetTopHeadlinesUseCase(sl<NewsRepository>()),
    );
    sl.registerLazySingleton(
      () => SearchNewsUseCase(sl<NewsRepository>()),
    );

    // ── BLoC ─────────────────────────────────────────────────────────────
    sl.registerFactory(
      () => NewsBloc(
        getTopHeadlinesUseCase: sl(),
        searchNewsUseCase: sl(),
      ),
    );
  }
}
