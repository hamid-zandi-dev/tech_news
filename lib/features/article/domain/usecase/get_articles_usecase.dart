import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/usecase/use_case.dart';
import 'package:tech_news/features/article/domain/model/article_model.dart';
import 'package:tech_news/features/article/domain/repository/articles_repository.dart';

class GetArticlesUsecase extends UseCaseStream<Either<Failure, List<ArticleModel>>, GetArticlesParams> {
  final ArticlesRepository _articlesRepository;

  GetArticlesUsecase(this._articlesRepository);

  @override
  Stream<Either<Failure, List<ArticleModel>>> call(GetArticlesParams input) {
    return _articlesRepository.getArticles(Params(query: input.query, to: input.to, from: input.from, page: input.page, pageSize: input.pageSize));
  }
}

class GetArticlesParams {
  final String query;
  final String to;
  final String from;
  final int page;
  final int pageSize;

  GetArticlesParams._(this.query, this.to, this.from, this.page, this.pageSize);

  static GetArticlesParams forQuery(String query, String to, String from, int page, int pageSize) {
    return GetArticlesParams._(query, to, from, page, pageSize);
  }
}