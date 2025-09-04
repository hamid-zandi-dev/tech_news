import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/features/article_details/domain/model/article_details_model.dart';

abstract class ArticleDetailsStatus {}

class ArticleDetailsLoadingStatus extends ArticleDetailsStatus {}

class ArticleDetailsLoadedStatus extends ArticleDetailsStatus {
  final ArticleDetailsModel articleDetailsModel;
  ArticleDetailsLoadedStatus(this.articleDetailsModel);
}

class ArticleDetailsErrorStatus extends ArticleDetailsStatus {
  final Failure failure;
  ArticleDetailsErrorStatus(this.failure);
}