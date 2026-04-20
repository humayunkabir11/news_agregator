import 'package:hive_flutter/hive_flutter.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<void> cacheTopHeadlines(List<ArticleModel> articles);
  Future<List<ArticleModel>> getCachedTopHeadlines();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  static const String boxName = 'news_box';

  @override
  Future<void> cacheTopHeadlines(List<ArticleModel> articles) async {
    final box = await Hive.openBox<ArticleModel>(boxName);
    await box.clear(); // Clear old cache
    for (var article in articles) {
      // Only cache valid articles to prevent messy offline UI
      if (article.modelTitle.isNotEmpty && article.modelTitle != '[Removed]' && article.modelTitle != 'No Title') {
         await box.add(article);
      }
    }
  }

  @override
  Future<List<ArticleModel>> getCachedTopHeadlines() async {
    final box = await Hive.openBox<ArticleModel>(boxName);
    return box.values.toList();
  }
}
