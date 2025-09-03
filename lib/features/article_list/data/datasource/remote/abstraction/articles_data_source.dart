import '../dto/articles_dto.dart';

abstract class ArticlesDataSource {
  Future<ArticlesDto> getArticles(String query, int page);
}
