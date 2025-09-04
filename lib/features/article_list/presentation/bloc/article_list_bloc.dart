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

  Future<void> _handleGetArticleListEvent(Emitter<ArticleListState> emit) async {
    if (_pageNumber <= _totalPage) {
      if (_articleListModel.isEmpty) {
        emit(GetArticleListState(ArticleListLoadingStatus()));
      }
      else {
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
    }
  }

  ArticleListState _handleFailureResponse(Failure failure) {
     return GetArticleListState(ArticleListErrorStatus(failure));
  }

  GetArticleListState _handleSuccessResponse(ArticlesModel articlesModel) {
    _articleListModel.addAll(articlesModel.articles);
    ArticleListLoadedStatus loadedStatus = ArticleListLoadedStatus(articlesModel.articles);
    _totalPage = Utils.getTotalPages(articlesModel.totalResults as int, Constants.articlesPageLimit);
    if (loadedStatus.list.isEmpty) {
      return GetArticleListState(ArticleListEmptyStatus());
    }
    else {
      return GetArticleListState(loadedStatus);
    }
  }
}
