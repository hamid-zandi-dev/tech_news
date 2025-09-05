import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news/features/article/domain/model/article_model.dart';
import 'package:tech_news/features/article/domain/model/article_source_model.dart';

void main() {
  group('Article Model Tests', () {
    late ArticleModel articleModel;
    late ArticleSourceModel sourceModel;

    setUp(() {
      sourceModel =
          ArticleSourceModel(id: "test-source-id", name: "Test Source");
      articleModel = ArticleModel(
        id: 1,
        source: sourceModel,
        author: "Test Author",
        title: "Test Article Title",
        description: "Test article description",
        url: "https://example.com/article",
        urlToImage: "https://example.com/image.jpg",
        publishedAt: "2024-01-01T10:00:00Z",
        content: "Test article content",
        queryTitle: "Microsoft",
      );
    });

    test('should create ArticleModel with all properties', () {
      expect(articleModel.id, equals(1));
      expect(articleModel.source, equals(sourceModel));
      expect(articleModel.author, equals("Test Author"));
      expect(articleModel.title, equals("Test Article Title"));
      expect(articleModel.description, equals("Test article description"));
      expect(articleModel.url, equals("https://example.com/article"));
      expect(articleModel.urlToImage, equals("https://example.com/image.jpg"));
      expect(articleModel.publishedAt, equals("2024-01-01T10:00:00Z"));
      expect(articleModel.content, equals("Test article content"));
      expect(articleModel.queryTitle, equals("Microsoft"));
    });

    test('should create ArticleModel with default values', () {
      final defaultArticle = ArticleModel(source: sourceModel);

      expect(defaultArticle.id, isNull);
      expect(defaultArticle.author, equals(""));
      expect(defaultArticle.title, equals(""));
      expect(defaultArticle.description, equals(""));
      expect(defaultArticle.url, equals(""));
      expect(defaultArticle.urlToImage, equals(""));
      expect(defaultArticle.publishedAt, equals(""));
      expect(defaultArticle.content, equals(""));
      expect(defaultArticle.queryTitle, equals(""));
    });

    test('should create ArticleModel.withId constructor', () {
      final articleWithId = ArticleModel.withId(
        id: 123,
        source: sourceModel,
        title: "Article with ID",
        queryTitle: "Apple",
      );

      expect(articleWithId.id, equals(123));
      expect(articleWithId.source, equals(sourceModel));
      expect(articleWithId.title, equals("Article with ID"));
      expect(articleWithId.queryTitle, equals("Apple"));
      expect(articleWithId.author, equals("")); // Default value
    });

    test('should allow modification of queryTitle', () {
      expect(articleModel.queryTitle, equals("Microsoft"));

      articleModel.queryTitle = "Apple";
      expect(articleModel.queryTitle, equals("Apple"));

      articleModel.queryTitle = "Google";
      expect(articleModel.queryTitle, equals("Google"));
    });

    test('should handle null id', () {
      final articleWithNullId = ArticleModel(
        id: null,
        source: sourceModel,
        title: "Article with null ID",
      );

      expect(articleWithNullId.id, isNull);
      expect(articleModel.title, equals("Test Article Title"));
    });

    test('should create multiple instances independently', () {
      final article1 = ArticleModel(
        id: 1,
        source: sourceModel,
        title: "Article 1",
        queryTitle: "Microsoft",
      );

      final article2 = ArticleModel(
        id: 2,
        source: sourceModel,
        title: "Article 2",
        queryTitle: "Apple",
      );

      expect(article1.id, equals(1));
      expect(article2.id, equals(2));
      expect(article1.title, equals("Article 1"));
      expect(article2.title, equals("Article 2"));
      expect(article1.queryTitle, equals("Microsoft"));
      expect(article2.queryTitle, equals("Apple"));

      // Modifying one should not affect the other
      article1.queryTitle = "Google";
      expect(article1.queryTitle, equals("Google"));
      expect(article2.queryTitle, equals("Apple"));
    });

    test('should handle empty strings correctly', () {
      final emptyArticle = ArticleModel(
        source: sourceModel,
        author: "",
        title: "",
        description: "",
        url: "",
        urlToImage: "",
        publishedAt: "",
        content: "",
        queryTitle: "",
      );

      expect(emptyArticle.author, equals(""));
      expect(emptyArticle.title, equals(""));
      expect(emptyArticle.description, equals(""));
      expect(emptyArticle.url, equals(""));
      expect(emptyArticle.urlToImage, equals(""));
      expect(emptyArticle.publishedAt, equals(""));
      expect(emptyArticle.content, equals(""));
      expect(emptyArticle.queryTitle, equals(""));
    });

    test('should handle long text content', () {
      final longContent =
          "This is a very long article content that contains multiple paragraphs and detailed information about the topic. " *
              100;

      final longArticle = ArticleModel(
        source: sourceModel,
        title: "Long Article",
        content: longContent,
      );

      expect(longArticle.content.length, greaterThan(1000));
      expect(longArticle.content,
          startsWith("This is a very long article content"));
    });
  });
}
