import 'article_details_source_model.dart';

class ArticleDetailsModel {
  final String id;
  final ArticleDetailsSourceModel source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  ArticleDetailsModel({
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
