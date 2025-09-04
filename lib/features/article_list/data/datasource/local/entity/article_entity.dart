import 'package:floor/floor.dart';

@Entity(tableName: "articles")
class ArticleEntity {

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String sourceId;
  final String sourceName;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  String queryTitle;

  ArticleEntity({
    this.id,
    this.sourceId = "",
    this.sourceName = "",
    this.author = "",
    this.title = "",
    this.description = "",
    this.url = "",
    this.urlToImage = "",
    this.publishedAt = "",
    this.content = "",
    required this.queryTitle,
  });

  // Named constructor for creating an instance with a specific ID
  ArticleEntity.withId({
    this.id,
    this.sourceId = "",
    this.sourceName = "",
    this.author = "",
    this.title = "",
    this.description = "",
    this.url = "",
    this.urlToImage = "",
    this.publishedAt = "",
    this.content = "",
    required this.queryTitle,
  });
}
