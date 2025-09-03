part of 'article_list_bloc.dart';

abstract class ArticleListState {}

class InitialState extends ArticleListState {}

class GetArticleListState extends ArticleListState {
  ArticleListStatus articleListStatus;
  GetArticleListState(this.articleListStatus);
}


