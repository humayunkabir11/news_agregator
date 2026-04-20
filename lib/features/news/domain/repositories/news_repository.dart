import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/article_entity.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<ArticleEntity>>> getTopHeadlines({String category = 'general'});
  Future<Either<Failure, List<ArticleEntity>>> searchNews(String query);
}
