
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/config/strings/api_endpoint.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({String category = 'general'});
  Future<List<ArticleModel>> searchNews(String query);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient apiClient;

  NewsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ArticleModel>> getTopHeadlines({String category = 'general'}) async {
    try {
      final response = await apiClient.get(
        api: ApiEndpoint.topHeadlines,
        params: {
          'country': 'us',
          'category': category,
          'apiKey': ApiEndpoint.newsApiKey,
        },
      );

      if (response.statusCode == 200) {
        final List dynamicList = response.data['articles'];
        return dynamicList
            .map((json) => ArticleModel.fromJson(json))
            .where((article) => article.modelTitle != '[Removed]' && article.modelTitle != 'No Title')
            .toList();
      } else {
        throw ServerException("");
      }
    } catch (e) {
      throw ServerException("");
    }
  }

  @override
  Future<List<ArticleModel>> searchNews(String query) async {
    try {
      final response = await apiClient.get(
        api: ApiEndpoint.everything,
        params: {
          'q': query,
          'apiKey': ApiEndpoint.newsApiKey,
          'sortBy': 'relevancy',
        },
      );

      if (response.statusCode == 200) {
        final List dynamicList = response.data['articles'];
        return dynamicList
            .map((json) => ArticleModel.fromJson(json))
            .where((article) => article.modelTitle != '[Removed]' && article.modelTitle != 'No Title')
            .toList();
      } else {
        throw ServerException("");
      }
    } catch (e) {
      throw ServerException("");
    }
  }
}
