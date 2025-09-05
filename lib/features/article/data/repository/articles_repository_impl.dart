import 'package:rxdart/rxdart.dart';
import 'package:dartz/dartz.dart';

import 'package:tech_news/core/error_handling/domain/failure.dart';
import 'package:tech_news/core/error_handling/mapper/error_mapper.dart';
import 'package:tech_news/core/utils/utils.dart';
import 'package:tech_news/features/article/data/datasource/local/abstraction/local_articles_data_source.dart';
import 'package:tech_news/features/article/data/datasource/local/entity/article_entity.dart';
import 'package:tech_news/features/article/data/datasource/local/mapper/local_article_mapper.dart';
import 'package:tech_news/features/article/data/datasource/remote/abstraction/remote_articles_data_source.dart';
import 'package:tech_news/features/article/data/datasource/remote/mapper/remote_article_mapper.dart';
import 'package:tech_news/features/article/domain/model/article_model.dart';
import 'package:tech_news/features/article/domain/model/articles_model.dart';
import 'package:tech_news/features/article/domain/repository/articles_repository.dart';

class ArticlesRepositoryImpl extends ArticlesRepository {
  final LocalArticleMapper _localArticleMapper;
  final RemoteArticleMapper _remoteArticleMapper;
  final RemoteArticlesDataSource _remoteArticlesDataSource;
  final LocalArticlesDataSource _localArticlesDataSource;

  ArticlesRepositoryImpl(
    this._remoteArticlesDataSource,
    this._remoteArticleMapper,
    this._localArticlesDataSource,
    this._localArticleMapper,
  );

  @override
  Stream<Either<Failure, List<ArticleModel>>> getArticles(Params params) {
    return _buildArticlesStream(params).shareReplay(maxSize: 1);
  }

  Stream<Either<Failure, List<ArticleModel>>> _buildArticlesStream(
      Params params) async* {
    try {
      // First, check if we have data for the specific page locally
      final localPageData = await _getLocalPageData(params);

      if (localPageData.isNotEmpty) {
        Logger.debug(
            "Loaded ${localPageData.length} articles for page ${params.page} from DB");
        Logger.debug(
            "Before circular sort: ${localPageData.map((e) => e.queryTitle).join(", ")}");
        final models = _localArticleMapper.mapToArticleModelList(localPageData);
        final sorted = _circularSortArticles(models);
        Logger.debug(
            "After circular sort: ${sorted.map((e) => e.queryTitle).join(", ")}");
        yield right(sorted);
        return;
      }

      // If no local data for this page, fetch from remote APIs
      try {
        final allArticles = <ArticleModel>[];

        // Make separate API calls for each company
        final companies = ["Microsoft", "Apple", "Google", "Tesla"];

        for (final company in companies) {
          try {
            final remote = await _remoteArticlesDataSource.getArticles(
                query: company,
                from: params.from,
                to: params.to,
                page: params.page,
                pageSize: params.pageSize ~/ companies.length);

            Logger.debug(
                "Loaded ${remote.articles?.length ?? 0} articles for $company from remote API");

            final model = _remoteArticleMapper.mapToArticlesModel(remote);

            // Assign the company name to each article
            for (final article in model.articles) {
              article.queryTitle = company;
            }

            allArticles.addAll(model.articles);
          } catch (e) {
            Logger.debug("Failed to fetch articles for $company: $e");
            // Continue with other companies even if one fails
            // Convert exception to failure for logging
            final failure = ErrorMapper.mapExceptionToFailure(e);
            Logger.error("Company $company failed: ${failure.message}",
                tag: 'Repository');
          }
        }

        if (allArticles.isNotEmpty) {
          Logger.debug(
              "[ArticlesRepository] Saving ${allArticles.length} total articles to DB");
          Logger.debug(
              "[ArticlesRepository] Articles by company: ${allArticles.map((e) => e.queryTitle).join(", ")}");

          // Apply circular sort to remote articles before saving and returning
          final sortedArticles = _circularSortArticles(allArticles);
          Logger.debug(
              "[ArticlesRepository] After circular sort: ${sortedArticles.map((e) => e.queryTitle).join(", ")}");
          await _saveArticles(sortedArticles);

          // Create final model with merged results
          final mergedModel = ArticlesModel(
            articles: sortedArticles,
            totalResults: sortedArticles.length,
          );

          yield right(mergedModel.articles);
        } else {
          yield left(ErrorMapper.createNoDataFoundFailure(
              'No articles found for the requested parameters'));
        }
      } catch (e) {
        // Convert any exception to domain failure
        final failure = ErrorMapper.mapExceptionToFailure(e);
        Logger.error("Repository error: ${failure.message}", tag: 'Repository');
        yield left(failure);
      }
    } catch (e) {
      // Convert any exception to domain failure
      final failure = ErrorMapper.mapExceptionToFailure(e);
      Logger.error("Repository error: ${failure.message}", tag: 'Repository');
      yield left(failure);
    }
  }

  Future<List<ArticleEntity>> _getLocalPageData(Params params) async {
    try {
      // Check if we have any data for the specific page locally
      // Since we're fetching multiple companies, we need to check if we have enough data
      // to satisfy the requested page size
      final companies = ["Microsoft", "Apple", "Google", "Tesla"];
      final allLocalArticles = <ArticleEntity>[];

      for (final company in companies) {
        final companyArticles =
            await _localArticlesDataSource.getArticlesWithPagingAndQuery(
                company,
                params.to,
                params.from,
                params.page,
                params.pageSize ~/ companies.length);
        allLocalArticles.addAll(companyArticles);
      }

      // If we have enough articles for this page, return them
      if (allLocalArticles.length >= params.pageSize) {
        return allLocalArticles;
      }

      // If we don't have enough articles, return empty list to trigger remote fetch
      return [];
    } catch (e) {
      Logger.debug("Error checking local page data: $e");
      return [];
    }
  }

  Future<void> _saveArticles(List<ArticleModel> articles) async {
    try {
      final entities = _localArticleMapper.mapToArticleEntityList(articles);
      await _localArticlesDataSource.saveAllArticles(entities);
    } catch (e) {
      Logger.error("Failed to save articles to database: $e",
          tag: 'Repository');
      // Convert database exception to domain failure and rethrow
      final failure = ErrorMapper.mapExceptionToFailure(e);
      throw failure;
    }
  }

  /// Circular sort that distributes articles in round-robin fashion by company name
  /// Example: Microsoft, Apple, Google, Tesla, Microsoft, Apple, Google, Tesla...
  List<ArticleModel> _circularSortArticles(List<ArticleModel> items) {
    final order = ["Microsoft", "Apple", "Google", "Tesla"];
    final buckets = {for (var o in order) o: <ArticleModel>[]};

    // Group articles by company
    for (var item in items) {
      if (buckets.containsKey(item.queryTitle)) {
        buckets[item.queryTitle]!.add(item);
      }
    }

    final sorted = <ArticleModel>[];
    int i = 0;
    int maxIterations = items.length * order.length; // Prevent infinite loop
    int iterations = 0;

    // Round-robin distribution: take one article from each company in order
    while (sorted.length < items.length && iterations < maxIterations) {
      final cat = order[i % order.length];
      if (buckets[cat]!.isNotEmpty) {
        sorted.add(buckets[cat]!.removeAt(0));
      }
      i++;
      iterations++;
    }

    // Add any remaining items that weren't sorted (fallback)
    for (var bucket in buckets.values) {
      sorted.addAll(bucket);
    }

    return sorted;
  }
}
