import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class SearchNewsUseCase implements UseCase<List<ArticleEntity>, String> {
  final NewsRepository repository;

  SearchNewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(String query) {
    return repository.searchNews(query);
  }
}
