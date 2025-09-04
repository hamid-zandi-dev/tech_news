import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import '../model/article_details_model.dart';

abstract class ArticleDetailsRepository {
  Future<Either<Failure, ArticleDetailsModel>> getArticleDetails(String id);
}