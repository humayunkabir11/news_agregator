import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String sourceName;
  final String content;

  const ArticleEntity({
    this.title = '',
    this.description = '',
    this.url = '',
    this.urlToImage = '',
    this.publishedAt = '',
    this.sourceName = '',
    this.content = '',
  });

  @override
  List<Object?> get props => [
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        sourceName,
        content,
      ];
}
