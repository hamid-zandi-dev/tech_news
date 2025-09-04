import 'package:dartz/dartz.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/usecase/use_case.dart';
import '../model/article_details_model.dart';
import '../repository/article_details_repository.dart';

class GetArticleDetailsUsecase extends UseCase<Either<Failure, ArticleDetailsModel>, GetArticleDetailsParams> {
  final ArticleDetailsRepository _articleDetailsRepository;
  GetArticleDetailsUsecase(this._articleDetailsRepository);

  @override
  Future<Either<Failure, ArticleDetailsModel>> call(GetArticleDetailsParams input) {
    return _articleDetailsRepository.getArticleDetails(input.id);
  }
}

class GetArticleDetailsParams {
  final String id;
  GetArticleDetailsParams._(this.id);

  static GetArticleDetailsParams forQuery(String id) {
    return GetArticleDetailsParams._(id);
  }
}