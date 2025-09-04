import '../dto/articles_dto.dart';

abstract class RemoteArticlesDataSource {
  Future<ArticlesDto> getArticles(String query, String from, String to, int page);
}
