import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<ArticleEntity>>> getTopHeadlines({String category = 'general'}) async {
    if (await connectionChecker.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.getTopHeadlines(category: category);
        // Only cache if it's the general category to save space, or cache all, user choice. Let's cache all requested categories by overwriting the box, or just cache 'general' as default.
        if (category == 'general') {
            localDataSource.cacheTopHeadlines(remoteArticles);
        }
        return right(remoteArticles);
      } on ServerException catch(e) {
        return left(Failure(message: 'Please use an apikey'));
      } catch (e) {
        return left(Failure(message: 'An unexpected error occurred: $e'));
      }
    } else {
      // Offline mode: Fetch from local cache if available and category is general (as we only cache general to avoid mixups)
      if (category == 'general') {
         try {
            final localArticles = await localDataSource.getCachedTopHeadlines();
            if (localArticles.isNotEmpty) {
               return right(localArticles); // Returning cached data
            } else {
               return left(Failure(message: 'No internet connection and no cached data available.'));
            }
         } catch (e) {
            return left(Failure(message: 'Failed to load cached data.'));
         }
      }
      return left(Failure(message: 'No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> searchNews(String query) async {
    if (await connectionChecker.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.searchNews(query);
        return right(remoteArticles);
      } on ServerException {
        return left(Failure(message: 'Please use an apikey'));
      } catch (e) {
        return left(Failure(message: 'An unexpected error occurred: $e'));
      }
    } else {
      return left(Failure(message: 'No internet connection.'));
    }
  }
}
