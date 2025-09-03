import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/usecase/use_case.dart';
import 'package:tech_news/features/news_list/domain/model/articles_model.dart';
import 'package:tech_news/features/news_list/domain/repository/articles_repository.dart';

class GetArticlesUsecase extends UseCase<Either<Failure, ArticlesModel>, ArticlesParams> {
  final ArticlesRepository _articlesRepository;
  GetArticlesUsecase(this._articlesRepository);

  @override
  Future<Either<Failure, ArticlesModel>> call(ArticlesParams input) {
    return _articlesRepository.getArticles(input.query, input.page);
  }
}

class ArticlesParams {
  final String query;
  final int page;
  ArticlesParams._(this.query, this.page);

  static ArticlesParams forQuery(String query, int page) {
    return ArticlesParams._(query, page);
  }
}