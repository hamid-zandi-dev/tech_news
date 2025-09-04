import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/features/article_list/domain/model/articles_model.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, ArticlesModel>> getArticles(String query, String from, String to, int page);
}