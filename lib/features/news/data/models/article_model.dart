import '../../domain/entities/article_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class ArticleModel extends ArticleEntity {
  @HiveField(0)
  final String modelTitle;
  
  @HiveField(1)
  final String modelDescription;
  
  @HiveField(2)
  final String modelUrl;
  
  @HiveField(3)
  final String modelUrlToImage;
  
  @HiveField(4)
  final String modelPublishedAt;
  
  @HiveField(5)
  final String modelSourceName;

  @HiveField(6)
  final String modelContent;

  const ArticleModel({
    required this.modelTitle,
    required this.modelDescription,
    required this.modelUrl,
    required this.modelUrlToImage,
    required this.modelPublishedAt,
    required this.modelSourceName,
    required this.modelContent,
  }) : super(
          title: modelTitle,
          description: modelDescription,
          url: modelUrl,
          urlToImage: modelUrlToImage,
          publishedAt: modelPublishedAt,
          sourceName: modelSourceName,
          content: modelContent,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      modelTitle: json['title'] ?? 'No Title',
      modelDescription: json['description'] ?? 'No Description',
      modelUrl: json['url'] ?? '',
      modelUrlToImage: json['urlToImage'] ?? '',
      modelPublishedAt: json['publishedAt'] ?? '',
      modelSourceName: json['source']?['name'] ?? 'Unknown Source',
      modelContent: json['content'] ?? 'No extra content available.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': modelTitle,
      'description': modelDescription,
      'url': modelUrl,
      'urlToImage': modelUrlToImage,
      'publishedAt': modelPublishedAt,
      'source': {'name': modelSourceName},
      'content': modelContent,
    };
  }
}
