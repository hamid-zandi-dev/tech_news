import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/custom_exception.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/utils/constants.dart';
import 'package:tech_news/core/utils/utils.dart';
import 'package:tech_news/features/article_list/data/datasource/local/entity/article_entity.dart';
import 'package:tech_news/features/article_list/data/datasource/local/mapper/local_article_mapper.dart';
import 'package:tech_news/features/article_list/data/datasource/remote/abstraction/remote_articles_data_source.dart';
import 'package:tech_news/features/article_list/domain/model/article_model.dart';
import 'package:tech_news/features/article_list/domain/model/articles_model.dart';
import 'package:tech_news/features/article_list/domain/repository/articles_repository.dart';
import '../datasource/local/abstraction/local_articles_data_source.dart';
import '../datasource/remote/mapper/remote_article_mapper.dart';

class ArticlesRepositoryImpl extends ArticlesRepository {

  final LocalArticleMapper _localArticleMapper;
  final RemoteArticleMapper _remoteArticleMapper;
  final RemoteArticlesDataSource _remoteArticlesDataSource;
  final LocalArticlesDataSource _localArticlesDataSource;

  ArticlesRepositoryImpl(
      this._remoteArticlesDataSource,
      this._remoteArticleMapper,
      this._localArticlesDataSource,
      this._localArticleMapper);

  @override
  Stream<Either<Failure, ArticlesModel>> getSortedArticles(String query, String to, String from, int page) async* {
    try {
      bool isConnected = await Utils.checkInternet();

      // Fetch local articles as a stream
      final localArticlesStream = _fetchLocalArticles(to, from, page);

      await for (final localArticles in localArticlesStream) {
        // If local articles exist, sort and yield them
        if(localArticles.isNotEmpty) {
          final sortedInOrderArticles = circularSort(localArticles);
          yield right(await _createArticlesModel(sortedInOrderArticles));
          return; // Stop further processing since we found local articles
        }
        if(isConnected) {
          // Then fetch remote data and update local storage
          final ArticlesModel articlesModel = await _fetchRemoteArticles(query, from, to, page);
          final List<ArticleModel> articles = _addQueryToArticles(articlesModel);
          await _saveArticles(articles);
        } else {
          // No local articles and no internet connection
          throw NoInternetConnectionException();
        }
      }

    } on NoInternetConnectionException {
      yield left(Failure.noInternetConnectionError);
    } on RestApiException catch (e) {
      yield left(_handleApiException(e));
    } catch (e) {
      yield left(Failure.unknownError);
    }
  }

  Stream<List<ArticleEntity>> _fetchLocalArticles(String to, String from, int page) {
    return _localArticlesDataSource.getArticlesWithPaging(to, from, page, Constants.articlesPageLimit);
  }

  Future<ArticlesModel> _fetchRemoteArticles(String query, String from, String to, int page) async {
    final response = await _remoteArticlesDataSource.getArticles(query, from, to, page);
    return _remoteArticleMapper.mapToArticlesModel(response);
  }

  List<ArticleModel> _addQueryToArticles(ArticlesModel articlesModel) {
    final List<String> queries = ["Microsoft", "Apple", "Google", "Tesla"];

    return articlesModel.articles.where((article) {
      for (var query in queries) {
        if (article.title.contains(query) ||
            article.description.contains(query) ||
            article.content.contains(query)) {
          article.queryTitle = query;
          return true;
        }
      }
      return false;
    }).toList();
  }

  Future<void> _saveArticles(List<ArticleModel> articles) async {
    final List<ArticleEntity> entities = _localArticleMapper.mapToArticleEntityList(articles);
    await _localArticlesDataSource.saveAllArticles(entities);
  }

  List<ArticleEntity> circularSort(List<ArticleEntity> items) {
    // Define the order
    final List<String> order = ['Microsoft', 'Apple', 'Google', 'Tesla'];

    // Create a map to hold buckets for each category
    final Map<String, List<ArticleEntity>> buckets = {
      'Microsoft': [],
      'Apple': [],
      'Google': [],
      'Tesla': [],
    };

    // Separate items into buckets
    for (var item in items) {
      if (buckets.containsKey(item.queryTitle)) {
        buckets[item.queryTitle]!.add(item);
      }
    }

    // Combine buckets in circular order
    List<ArticleEntity> sortedItems = [];
    int maxLength = items.length;
    int index = 0;

    while (sortedItems.length < maxLength) {
      String category = order[index % order.length];
      if (buckets[category]!.isNotEmpty) {
        sortedItems.add(buckets[category]!.removeAt(0));
      }
      index++;
    }
     return sortedItems;
  }

  // offline data is valid for 10 minutes, after that is stale
  bool isLocalDataStale(List<ArticleEntity> localArticles) {
    if(localArticles.isEmpty){
      return false;
    }
    final DateTime latestPublishedAt = localArticles
        .map((article) => DateTime.parse(article.publishedAt))
        .reduce((a, b) => a.isAfter(b) ? a : b);

    final DateTime staleThreshold = DateTime.now().subtract(const Duration(minutes: 10));
    return latestPublishedAt.isBefore(staleThreshold);
  }

  Future<ArticlesModel> _createArticlesModel(List<ArticleEntity> articles) async {
    final int totalResults = await _localArticlesDataSource.getArticlesCount() ?? 0;
    final List<ArticleModel> articleModelList = _localArticleMapper.mapToArticleModelList(articles);
    return ArticlesModel(articles: articleModelList, totalResults: totalResults);
  }

  Failure _handleApiException(RestApiException e) {
    if (e.errorCode != null) {
      if (e.errorCode! >= RestApiError.fromServerError && e.errorCode! <= RestApiError.toServerError) {
        return Failure.serverError;
      }
      return Failure.unknownError;
    }
    return Failure.unknownError;
  }
}