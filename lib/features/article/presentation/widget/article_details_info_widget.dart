import 'package:flutter/material.dart';
import 'package:tech_news/features/article/domain/model/article_model.dart';

class ArticleDetailsInfoWidget extends StatefulWidget {
  final ArticleModel articleModel;
  const ArticleDetailsInfoWidget({super.key, required this.articleModel});

  @override
  State<ArticleDetailsInfoWidget> createState() =>
      _ArticleDetailsInfoWidgetState();
}

class _ArticleDetailsInfoWidgetState extends State<ArticleDetailsInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Card(
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createArticleTitleItem(widget.articleModel),
              _createArticleDescriptionItem(widget.articleModel),
              _createArticlePublishedDateItem(widget.articleModel),
              _createArticleContentItem(widget.articleModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createArticleTitleItem(ArticleModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          model.title,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _createArticleDescriptionItem(ArticleModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          model.description,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _createArticleContentItem(ArticleModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          model.content,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _createArticlePublishedDateItem(ArticleModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          model.publishedAt,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
