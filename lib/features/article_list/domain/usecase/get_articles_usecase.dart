import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/usecase/use_case.dart';
import 'package:tech_news/features/article_list/domain/model/articles_model.dart';
import 'package:tech_news/features/article_list/domain/repository/articles_repository.dart';

class GetArticlesUsecase extends UseCase<Either<Failure, ArticlesModel>, GetArticlesParams> {
  final ArticlesRepository _articlesRepository;
  GetArticlesUsecase(this._articlesRepository);

  @override
  Future<Either<Failure, ArticlesModel>> call(GetArticlesParams input) {
    return _articlesRepository.getArticles(input.query, input.from, input.to, input.page);
  }
}

class GetArticlesParams {
  final String query;
  final String from;
  final String to;
  final int page;
  GetArticlesParams._(this.query, this.from, this.to, this.page);

  static GetArticlesParams forQuery(String query, String from, String to, int page) {
    return GetArticlesParams._(query, from, to, page);
  }
}