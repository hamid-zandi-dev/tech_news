import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/usecase/use_case.dart';
import 'package:tech_news/features/article_list/domain/model/articles_model.dart';
import 'package:tech_news/features/article_list/domain/repository/articles_repository.dart';

class GetArticlesUsecase extends UseCaseStream<Either<Failure, ArticlesModel>, GetArticlesParams> {
  final ArticlesRepository _articlesRepository;

  GetArticlesUsecase(this._articlesRepository);

  @override
  Stream<Either<Failure, ArticlesModel>> call(GetArticlesParams input) {
    return _articlesRepository.getSortedArticles(input.query, input.to, input.from, input.page);
  }
}

class GetArticlesParams {
  final String query;
  final String to;
  final String from;
  final int page;

  GetArticlesParams._(this.query, this.to, this.from, this.page);

  static GetArticlesParams forQuery(String query, String to, String from, int page) {
    return GetArticlesParams._(query, to, from, page);
  }
}