part of 'article_list_bloc.dart';

@immutable
abstract class ArticleListEvent {}

class GetArticleListEvent extends ArticleListEvent {
  GetArticleListEvent();
}

class PageToInitial extends ArticleListEvent {}
