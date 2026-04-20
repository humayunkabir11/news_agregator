import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_event.dart';
import 'news_state.dart';
import '../../domain/usecases/get_top_headlines_usecase.dart';
import '../../domain/usecases/search_news_usecase.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlinesUseCase getTopHeadlinesUseCase;
  final SearchNewsUseCase searchNewsUseCase;

  NewsBloc({
    required this.getTopHeadlinesUseCase,
    required this.searchNewsUseCase,
  }) : super(NewsInitial()) {
    on<FetchTopHeadlines>(_onFetchTopHeadlines);
    on<SearchNews>(_onSearchNews);
  }

  Future<void> _onFetchTopHeadlines(FetchTopHeadlines event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    final result = await getTopHeadlinesUseCase(event.category);
    result.fold(
      (failure) {
        if (failure.message?.contains("cached data available") == true || failure.message?.contains("offline") == true) {
          emit(NewsError(failure.message ?? 'Unknown Error'));
        } else {
           emit(NewsError(failure.message ?? 'Unknown Error'));
        }
      },
      (articles) {
        if (articles.isEmpty) {
          emit(const NewsEmpty("No articles found for this category."));
        } else {
          // If we want to detect if it's offline loaded without explicitly adding a method to usecase,
          // we assume if it's successful it might be either. The UI can just show them.
          emit(NewsLoaded(articles: articles));
        }
      },
    );
  }

  Future<void> _onSearchNews(SearchNews event, Emitter<NewsState> emit) async {
    if (event.query.isEmpty) {
       add(const FetchTopHeadlines());
       return;
    }
    emit(NewsLoading());
    final result = await searchNewsUseCase(event.query);
    result.fold(
      (failure) => emit(NewsError(failure.message ?? 'Unknown Error')),
      (articles) {
        if (articles.isEmpty) {
          emit(const NewsEmpty("No articles found for your search."));
        } else {
          emit(NewsLoaded(articles: articles));
        }
      },
    );
  }
}
