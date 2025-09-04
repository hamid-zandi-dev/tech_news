part of 'article_details_bloc.dart';

abstract class ArticleDetailsState {}

class InitialState extends ArticleDetailsState {}

class GetArticleDetailsState extends ArticleDetailsState {
  ArticleDetailsStatus articleDetailsStatus;
  GetArticleDetailsState(this.articleDetailsStatus);
}


