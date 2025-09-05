import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/utils/constants.dart';
import 'package:tech_news/core/utils/utils.dart';
import 'package:tech_news/features/article_list/domain/model/article_model.dart';
import 'package:tech_news/features/article_list/domain/model/articles_model.dart';
import 'package:tech_news/features/article_list/domain/usecase/get_articles_usecase.dart';
import 'package:tech_news/features/article_list/presentation/bloc/article_list_status.dart';

part 'article_list_event.dart';
part 'article_list_state.dart';

class ArticleListBloc extends Bloc<ArticleListEvent, ArticleListState> {
  final String _query = "Microsoft OR Apple OR Google OR Tesla";
  final GetArticlesUsecase _getArticlesUsecase;
  final List<ArticleModel> _articleListModel = [];
  int _pageNumber = 1;
  int _totalPage = 1;
  String _to = "";
  String _from = "";

  ArticleListBloc(this._getArticlesUsecase) : super(InitialState()) {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
    _to = dateFormat.format(now);
    _from = dateFormat.format(now.subtract(const Duration(days: 2)));
    on<PageToInitial>((event, emit) => _handlePageToInitial(emit));
    on<GetArticleListEvent>((event, emit) => _handleGetArticleListEvent(emit));
  }

  void _handlePageToInitial(Emitter<ArticleListState> emit) {
    _pageNumber = 1;
    _totalPage = 1;
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
    _to = dateFormat.format(now);
    _from = dateFormat.format(now.subtract(const Duration(days: 2)));
    emit(InitialState());
  }

  Future<void> _handleGetArticleListEvent(
      Emitter<ArticleListState> emit) async {
    Logger.debug(
        'Fetching articles for page $_pageNumber, total pages: $_totalPage, current articles: ${_articleListModel.length}',
        tag: 'ArticleListBloc');

    if (_pageNumber <= _totalPage) {
      if (_articleListModel.isEmpty) {
        emit(GetArticleListState(ArticleListLoadingStatus()));
      } else {
        emit(GetArticleListState(ArticleListLoadingMoreStatus()));
      }
      final resultStream = _getArticlesUsecase(
          GetArticlesParams.forQuery(_query, _to, _from, _pageNumber));
      await emit.forEach<Either<Failure, ArticlesModel>>(
        resultStream,
        onData: (result) {
          return result.fold(
            (failure) => _handleFailureResponse(failure),
            (success) => _handleSuccessResponse(success),
          );
        },
        onError: (_, __) =>
            GetArticleListState(ArticleListErrorStatus(Failure.unknownError)),
      );
    } else {
      Logger.debug(
          'No more pages to load. Current page: $_pageNumber, Total pages: $_totalPage',
          tag: 'ArticleListBloc');
    }
  }

  ArticleListState _handleFailureResponse(Failure failure) {
    Logger.error('Article fetch failed: ${failure.toString()}',
        tag: 'ArticleListBloc');

    // If we have existing articles and this is a pagination request,
    // return loaded more error status instead of full error
    if (_articleListModel.isNotEmpty) {
      return GetArticleListState(ArticleListLoadedMoreErrorStatus());
    }

    return GetArticleListState(ArticleListErrorStatus(failure));
  }

  GetArticleListState _handleSuccessResponse(ArticlesModel articlesModel) {
    Logger.debug(
        'Articles fetched successfully: ${articlesModel.articles.length} articles, total results: ${articlesModel.totalResults}',
        tag: 'ArticleListBloc');

    _articleListModel.addAll(articlesModel.articles);
    ArticleListLoadedStatus loadedStatus =
        ArticleListLoadedStatus(_articleListModel);
    _totalPage = Utils.getTotalPages(
        articlesModel.totalResults as int, Constants.articlesPageLimit);

    // Increment page number for next pagination
    _pageNumber++;

    Logger.debug(
        'Updated state - Page: $_pageNumber, Total Pages: $_totalPage, Total Articles: ${_articleListModel.length}',
        tag: 'ArticleListBloc');

    if (loadedStatus.list.isEmpty) {
      return GetArticleListState(ArticleListEmptyStatus());
    } else {
      return GetArticleListState(loadedStatus);
    }
  }
}
