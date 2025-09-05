import 'package:tech_news/features/article/data/datasource/local/entity/article_entity.dart';

import '../abstraction/local_articles_data_source.dart';
import '../dao/article_dao.dart';


class LocalArticlesDataSourceImpl implements LocalArticlesDataSource {
  final ArticleDao _articleDao;
  LocalArticlesDataSourceImpl(this._articleDao);

  @override
  Future<ArticleEntity?> getArticleById(String articleId) {
    return _articleDao.getArticleById(articleId);
  }

  @override
  Future<List<ArticleEntity>> getAllArticlesWithQuery(String query, String to, String from) async{
    return _articleDao.getArticlesWithQuery(query, to, from);
  }

  @override
  Future<List<ArticleEntity>> getArticlesWithTitle(String title, String to, String from) {
    return _articleDao.getArticlesWithTitle(title, to, from);
  }

  @override
  Stream<List<ArticleEntity>> getAllArticles() {
    return _articleDao.getAllArticles();
  }

  @override
  Stream<List<ArticleEntity>> getArticlesWithPaging(String to, String from, int page, int pageLimit) {
    return _articleDao.getArticlesWithPaging(to, from, page, pageLimit);
  }

  @override
  Future<List<ArticleEntity>> getArticlesWithPagingAndQuery(String query, String to, String from, int page, int pageLimit) {
    return _articleDao.getArticlesWithPagingAndQuery(query, to, from, page, pageLimit);
  }

  @override
  Future<int> saveArticle(ArticleEntity articleEntity) {
    return _articleDao.insertArticle(articleEntity);
  }

  @override
  Future<void> saveAllArticles(List<ArticleEntity> entities) async {
    await _articleDao.insertArticles(entities);
  }

  @override
  Future<int> updateArticle(ArticleEntity articleEntity) {
    return _articleDao.updateArticle(articleEntity);
  }

  @override
  Future<void> deleteArticle(ArticleEntity articleEntity) async{
    return _articleDao.deleteArticle(articleEntity);
  }

  @override
  Future<int?> getArticlesCount() async{
    return _articleDao.getArticlesCount();
  }

}