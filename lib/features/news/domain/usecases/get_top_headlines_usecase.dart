import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlinesUseCase implements UseCase<List<ArticleEntity>, String> {
  final NewsRepository repository;

  GetTopHeadlinesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(String category) {
    return repository.getTopHeadlines(category: category);
  }
}
