import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/features/article/domain/model/article_model.dart';

abstract class ArticlesRepository {
  Stream<Either<Failure, List<ArticleModel>>> getArticles(Params params);
}

class Params {
  final String query;
  final String from;
  final String to;
  final int page;
  final int pageSize;
  const Params({
    required this.query,
    required this.from,
    required this.to,
    required this.page,
    required this.pageSize,
  });
}
