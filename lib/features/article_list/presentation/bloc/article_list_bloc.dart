import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/utils/constants.dart';
import 'package:tech_news/core/utils/utils.dart';
import 'package:tech_news/features/article_list/domain/model/article_model.dart';
import 'package:tech_news/features/article_list/domain/usecase/get_articles_usecase.dart';
import 'package:tech_news/features/article_list/presentation/bloc/article_list_status.dart';

part 'article_list_event.dart';
part 'article_list_state.dart';

class ArticleListBloc extends Bloc<ArticleListEvent, ArticleListState> {
  final String _query = "Microsoft OR Apple OR Google OR Tesla";
  final GetArticlesUsecase _getArticlesUsecase;
  final List<ArticleModel> _articleListModel = [];
  int _pageNumber = 1;
  String _to = "";
  String _from = "";
  bool _endOfData = false;

  ArticleListBloc(this._getArticlesUsecase) : super(InitialState()) {
    on<PageToInitial>((event, emit) => _handlePageToInitial(emit));
    on<GetArticleListEvent>((event, emit) => _handleGetArticleListEvent(emit));
  }

  _handlePageToInitial(Emitter<ArticleListState> emit) {
    _pageNumber = 1;
    _endOfData = false;
    _articleListModel.clear();
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
    _to = dateFormat.format(now);
    _from = dateFormat.format(now.subtract(const Duration(days: 2)));
    emit(InitialState());
  }

  Future _handleGetArticleListEvent(Emitter<ArticleListState> emit) async {
    Logger.debug(
        'Fetching articles for page $_pageNumber, current articles: ${_articleListModel.length}',
        tag: 'ArticleListBloc');

    if (!_endOfData) {
      if (_articleListModel.isEmpty) {
        emit(GetArticleListState(ArticleListLoadingStatus()));
      } else {
        emit(GetArticleListState(ArticleListLoadingMoreStatus()));
      }
      final resultStream = _getArticlesUsecase(GetArticlesParams.forQuery(
          _query, _to, _from, _pageNumber, Constants.articlesPageLimit));
      await emit.forEach<Either<Failure, List<ArticleModel>>>(
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
      Logger.debug('No more pages to load. Current page: $_pageNumber',
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

  GetArticleListState _handleSuccessResponse(List<ArticleModel> articles) {
    Logger.debug(
        'Articles fetched successfully: ${articles.length} articles',
        tag: 'ArticleListBloc');

    if (articles.isNotEmpty) {
      _articleListModel.addAll(articles);

      // Increment page number for next pagination
      _pageNumber++;
    }else{
      _endOfData = true;
    }
    ArticleListLoadedStatus loadedStatus =
        ArticleListLoadedStatus(_articleListModel);

    Logger.debug(
        'Updated state - Page: $_pageNumber, Total Articles: ${_articleListModel.length}',
        tag: 'ArticleListBloc');

    if (loadedStatus.list.isEmpty) {
      return GetArticleListState(ArticleListEmptyStatus());
    } else {
      return GetArticleListState(loadedStatus);
    }
  }
}
