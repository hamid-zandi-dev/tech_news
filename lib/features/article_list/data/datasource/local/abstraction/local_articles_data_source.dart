import '../entity/article_entity.dart';

abstract class LocalArticlesDataSource {
  Stream<List<ArticleEntity>> getArticlesWithPaging(String to, String from, int page, int pageLimit);
  Future<List<ArticleEntity>> getArticlesWithPagingAndQuery(String query,String to, String from, int page, int pageLimit);
  Future<List<ArticleEntity>> getAllArticlesWithQuery(String query, String to, String from);
  Future<List<ArticleEntity>> getArticlesWithTitle(String title, String to, String from);
  Future<List<ArticleEntity>> getAllArticles(String to, String from);
  Future<ArticleEntity?> getArticleById(String articleId);
  Future<int> saveArticle(ArticleEntity articleEntity);
  Future<void> saveAllArticles(List<ArticleEntity> entities);
  Future<int> updateArticle(ArticleEntity articleEntity);
  Future<void> deleteArticle(ArticleEntity articleEntity);
  Future<int?> getArticlesCount();
}
