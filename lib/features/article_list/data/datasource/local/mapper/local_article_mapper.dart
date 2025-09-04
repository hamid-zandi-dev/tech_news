import 'package:tech_news/core/utils/entity_mapper.dart';
import 'package:tech_news/features/article_list/data/datasource/local/entity/article_entity.dart';
import 'package:tech_news/features/article_list/domain/model/article_model.dart';
import 'package:tech_news/features/article_list/domain/model/article_source_model.dart';
import 'package:uuid/uuid.dart';

class LocalArticleMapper extends EntityMapper<ArticleEntity, ArticleModel> {

  @override
  ArticleModel mapFromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id ?? 0,
      source:  ArticleSourceModel(id: entity.sourceId, name: entity.sourceName),
      queryTitle: entity.queryTitle,
      author: entity.author,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      content: entity.content,
    );
  }

  @override
  ArticleEntity mapToEntity(ArticleModel model) {
    return ArticleEntity.withId(
        id: model.id,
        sourceId: model.source.id,
        sourceName: model.source.name,
        queryTitle: model.queryTitle,
        author: model.author,
        title: model.title,
        description: model.description,
        url: model.url,
        urlToImage: model.urlToImage,
        publishedAt: model.publishedAt,
        content: model.content);
  }

  List<ArticleModel> mapToArticleModelList(List<ArticleEntity> articlesEntity) {
    return articlesEntity.map((articleEntity) => mapFromEntity(articleEntity)).toList();
  }

  List<ArticleEntity> mapToArticleEntityList(List<ArticleModel> articlesModel) {
    return articlesModel.map((articleModel) => mapToEntity(articleModel)).toList();
  }
}
