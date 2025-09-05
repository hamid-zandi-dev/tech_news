import '../dto/articles_dto.dart';

abstract class RemoteArticlesDataSource {
  Future<ArticlesDto> getArticles({
    required String query,
    required String from,
    required String to,
    required int page,
    required int pageSize
  });
}
