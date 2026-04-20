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
    try {
      final box = await Hive.openBox<ArticleModel>(boxName);
      await box.clear();
      for (var article in articles) {
        if (article.modelTitle.isNotEmpty && article.modelTitle != '[Removed]' && article.modelTitle != 'No Title') {
           await box.add(article);
        }
      }
    } catch (e) {
      // Schema changed or corrupted, nuke it
      await Hive.deleteBoxFromDisk(boxName);
    }
  }

  @override
  Future<List<ArticleModel>> getCachedTopHeadlines() async {
    try {
      final box = await Hive.openBox<ArticleModel>(boxName);
      return box.values.toList();
    } catch (e) {
      await Hive.deleteBoxFromDisk(boxName);
      return [];
    }
  }
}
