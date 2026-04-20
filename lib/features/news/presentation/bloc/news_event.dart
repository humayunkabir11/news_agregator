import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopHeadlines extends NewsEvent {
  final String category;

  const FetchTopHeadlines({this.category = 'general'});

  @override
  List<Object?> get props => [category];
}

class SearchNews extends NewsEvent {
  final String query;

  const SearchNews(this.query);

  @override
  List<Object?> get props => [query];
}
