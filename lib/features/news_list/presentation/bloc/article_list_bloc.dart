import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/utils/Constants.dart';
import 'package:tech_news/features/news_list/domain/model/article_model.dart';
import 'package:tech_news/features/news_list/domain/model/articles_model.dart';
import 'package:tech_news/features/news_list/domain/usecase/get_articles_usecase.dart';
import 'package:tech_news/features/news_list/presentation/bloc/article_list_status.dart';

part 'article_list_event.dart';
part 'article_list_state.dart';

class ArticleListBloc extends Bloc<ArticleListEvent, ArticleListState> {
  final GetArticlesUsecase _getArticlesUsecase;
  final List<ArticleModel> _articleListModel = [];
  ArticleListBloc(this._getArticlesUsecase) : super(InitialState()) {
    articleListBloc();
  }

  void articleListBloc() {
    int pageNumber = 1;
    int totalPage = 1;
    on<PageToInitial>((event, emit) {
      pageNumber = 1;
      totalPage = 1;
      _articleListModel.clear();
    });
    on<GetArticleListEvent>((event, emit) async {
      if (pageNumber <= totalPage) {
        if (_articleListModel.isEmpty) {
          emit(GetArticleListState(ArticleListLoadingStatus()));
        }
        else {
          emit(GetArticleListState(ArticleListLoadingMoreStatus()));
        } // todo: add proper query param
        final result = await _getArticlesUsecase(GetArticlesParams.forQuery("" ,pageNumber));
        result.fold(
                (failure) {
              if (_articleListModel.isEmpty) {
                _handleFailureResponse(emit, failure);
              }
              else {
                emit(GetArticleListState(ArticleListLoadedMoreErrorStatus()));
              }
            },
                (success) {
              _handleSuccessResponse(emit, success);
              totalPage = (success.totalResults / Constants.articlesLimit) as int;
              pageNumber++;
            }
        );
      }

    });
  }

  void _handleFailureResponse(Emitter<ArticleListState> emit, Failure failure) {
    emit(GetArticleListState(ArticleListErrorStatus(failure)));
  }

  void _handleSuccessResponse(Emitter<ArticleListState> emit, ArticlesModel articlesModel) {
    _articleListModel.addAll(articlesModel.articles);
    ArticleListLoadedStatus loadedStatus = ArticleListLoadedStatus(_articleListModel);
    if (loadedStatus.list.isEmpty) {
      emit(GetArticleListState(ArticleListEmptyStatus()));
    }
    else {
      emit(GetArticleListState(loadedStatus));
    }
  }
}
