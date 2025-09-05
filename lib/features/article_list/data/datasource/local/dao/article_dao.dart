import 'package:floor/floor.dart';
import 'package:tech_news/features/article_list/data/datasource/local/entity/article_entity.dart';
import 'dart:async';

@dao
abstract class ArticleDao {

  @Query('SELECT * FROM articles')
  Stream<List<ArticleEntity>> getAllArticles();

  @Query('''
    SELECT * FROM articles 
    WHERE publishedAt <= :to AND publishedAt > :from 
    ORDER BY publishedAt 
    LIMIT :pageLimit 
    OFFSET (:page - 1) * :pageLimit
  ''')
  Stream<List<ArticleEntity>> getArticlesWithPaging(String to, String from, int page, int pageLimit);

  @Query('''
    SELECT * FROM articles 
    WHERE publishedAt <= :to AND publishedAt > :from AND queryName = :query 
    ORDER BY publishedAt 
    LIMIT :pageLimit 
    OFFSET (:page - 1) * :pageLimit
  ''')
  Future<List<ArticleEntity>> getArticlesWithPagingAndQuery(String query, String to, String from, int page, int pageLimit);

  @Query('''
    SELECT * FROM articles 
    WHERE publishedAt <= :to AND publishedAt > :from AND queryName = :query 
    ORDER BY publishedAt 
  ''')
  Future<List<ArticleEntity>> getArticlesWithQuery(String query, String to, String from);

  @Query('''
    SELECT * FROM articles 
    WHERE publishedAt <= :to AND publishedAt > :from AND title = :title 
    ORDER BY publishedAt 
  ''')
  Future<List<ArticleEntity>> getArticlesWithTitle(String title, String to, String from);

  @Query('''
    SELECT * FROM articles 
    WHERE id = :articleId 
  ''')
  Future<ArticleEntity?> getArticleById(String articleId);

  @insert
  Future<int> insertArticle(ArticleEntity articleEntity);

  @insert
  Future<void> insertArticles(List<ArticleEntity> entities);

  @update
  Future<int> updateArticle(ArticleEntity articleEntity);

  @delete
  Future<void> deleteArticle(ArticleEntity articleEntity);

  @Query('SELECT COUNT(*) FROM articles')
  Future<int?> getArticlesCount();

}