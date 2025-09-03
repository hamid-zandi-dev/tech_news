import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/features/news_list/domain/model/article_model.dart';

abstract class ArticleListStatus {}

class ArticleListLoadingStatus extends ArticleListStatus {}

class ArticleListLoadingMoreStatus extends ArticleListStatus {}

class ArticleListEmptyStatus extends ArticleListStatus {}

class ArticleListLoadedStatus extends ArticleListStatus {
  List<ArticleModel> list = [];
  ArticleListLoadedStatus(this.list);
}

class ArticleListErrorStatus extends ArticleListStatus {
  final Failure failure;
  ArticleListErrorStatus(this.failure);
}

class ArticleListLoadedMoreErrorStatus extends ArticleListStatus {
  ArticleListLoadedMoreErrorStatus();
}
