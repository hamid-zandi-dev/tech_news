part of 'article_details_bloc.dart';

@immutable
abstract class ArticleDetailsEvent {}

class GetArticleDetailsEvent extends ArticleDetailsEvent {
  final String articleId;
  GetArticleDetailsEvent(this.articleId);
}
