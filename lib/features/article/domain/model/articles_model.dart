import 'article_model.dart';

class ArticlesModel {
  final String status;
  final num totalResults;
  final List<ArticleModel> articles;

  ArticlesModel({
    this.status = "",
    this.totalResults = 0,
    required this.articles,
  });
}
