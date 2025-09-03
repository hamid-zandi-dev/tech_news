import 'package:tech_news/core/utils/model_mapper.dart';
import 'package:tech_news/features/news_list/data/datasource/remote/dto/article_dto.dart';
import 'package:tech_news/features/news_list/domain/model/article_model.dart';
import 'package:tech_news/features/news_list/domain/model/article_source_model.dart';
import 'package:uuid/uuid.dart';

import '../dto/article_source_dto.dart';

class RemoteArticleMapper extends ModelMapper<ArticleModel, ArticleDto> {

  @override
  ArticleDto mapFromModel(ArticleModel model) {
    return ArticleDto(
      source: ArticleSourceDto(id: model.source.id, name: model.source.name) ,
      author: model.author,
      title: model.title,
      description: model.description,
      url: model.url,
      urlToImage: model.urlToImage,
      publishedAt: model.publishedAt,
      content: model.content,
    );
  }

  @override
  ArticleModel mapToModel(ArticleDto dto) {
    return ArticleModel(
        id: const Uuid().v4(),
        source: ArticleSourceModel(id: dto.source?.id ?? "", name: dto.source?.name ?? ""),
        author: dto.author ?? "",
        title: dto.title ?? "",
        description: dto.description ?? "",
        url: dto.url ?? "",
        urlToImage: dto.urlToImage ?? "",
        publishedAt: dto.publishedAt ?? "",
        content: dto.content ?? "");
  }
}
