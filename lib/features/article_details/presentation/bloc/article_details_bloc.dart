import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:tech_news/features/article_details/domain/usecase/get_article_details_usecase.dart';
import 'package:tech_news/features/article_details/presentation/bloc/article_details_status.dart';

part 'article_details_event.dart';
part 'article_details_state.dart';

class ArticleDetailsBloc extends Bloc<ArticleDetailsEvent, ArticleDetailsState> {
  final GetArticleDetailsUsecase _getArticleDetailUsecase;
  ArticleDetailsBloc(this._getArticleDetailUsecase,
      ) : super(InitialState()) {
    initArticleDetailsBloc();
  }

  void initArticleDetailsBloc() {
    on<GetArticleDetailsEvent>((event, emit) async {
      emit(GetArticleDetailsState(ArticleDetailsLoadingStatus()));

      final result = await _getArticleDetailUsecase(GetArticleDetailsParams.forQuery(event.articleId));
      result.fold(
              (failure) {
            emit(GetArticleDetailsState(ArticleDetailsErrorStatus(failure)));
          },
              (success) {
            emit(GetArticleDetailsState(ArticleDetailsLoadedStatus(success)));
          }
      );
    }, transformer: restartable(),);
  }
}
