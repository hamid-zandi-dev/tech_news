import 'package:tech_news/core/error_handling/custom_exception.dart';
import 'package:tech_news/core/utils/constants.dart';
import 'package:tech_news/features/news_list/data/datasource/local/mapper/local_article_mapper.dart';
import 'package:tech_news/features/news_list/data/datasource/remote/abstraction/articles_data_source.dart';
import 'package:tech_news/features/news_list/domain/repository/articles_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/features/news_list/domain/model/articles_model.dart';

import '../datasource/remote/mapper/remote_article_mapper.dart';

class ArticlesRepositoryImpl extends ArticlesRepository {

  final LocalArticleMapper _localArticleMapper;
  final RemoteArticleMapper _remoteArticleMapper;
  final ArticlesDataSource _articlesDataSource;

  ArticlesRepositoryImpl(this._articlesDataSource, this._localArticleMapper, this._remoteArticleMapper);

  @override
  Future<Either<Failure, ArticlesModel>> getArticles(String query, int page) async {
    try {
      final response = await _articlesDataSource.getArticles(query ,page);
      ArticlesModel articlesModel = _remoteArticleMapper.mapToArticlesModel(response);
      return right(articlesModel);
    }
    on NoInternetConnectionException {
      return left(Failure.noInternetConnectionError);
    }
    on RestApiException catch (e) {
      if (e.errorCode != null) {
        if (e.errorCode! >= RestApiError.fromServerError && e.errorCode! <= RestApiError.toServerError) {
          return left(Failure.serverError,);
        }
        return left(Failure.unknownError);
      }
      else {
        return left(Failure.unknownError);
      }
    }
    catch(e) {
      return left(Failure.unknownError,);
    }
  }
}