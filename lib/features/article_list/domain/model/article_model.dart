import 'article_source_model.dart';

class ArticleModel {
  final String id;
  final ArticleSourceModel source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  ArticleModel({
    required this.id,
    required this.source,
    this.author = "",
    this.title = "",
    this.description = "",
    this.url = "",
    this.urlToImage = "",
    this.publishedAt = "",
    this.content = "",
  });
}
