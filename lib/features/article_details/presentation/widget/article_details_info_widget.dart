import 'package:flutter/material.dart';
import 'package:tech_news/core/theme/theme_manager.dart';
import 'package:tech_news/features/article_details/domain/model/article_details_model.dart';

class ArticleDetailsInfoWidget extends StatefulWidget {
  final ArticleDetailsModel articleDetailsModel;
  const ArticleDetailsInfoWidget({super.key, required this.articleDetailsModel});

  @override
  State<ArticleDetailsInfoWidget> createState() => _ArticleDetailsInfoWidgetState();
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
              _createArticleTitleItem(widget.articleDetailsModel),
              _createArticleDescriptionItem(widget.articleDetailsModel),
              _createArticlePublishedDateItem(widget.articleDetailsModel),
              _createArticleContentItem(widget.articleDetailsModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createArticleTitleItem(ArticleDetailsModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          model.title,
          style: const TextStyle(
              fontSize: 14
          ),
        ),
      ),
    );
  }

  Widget _createArticleDescriptionItem(ArticleDetailsModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          model.description,
          style: const TextStyle(
              fontSize: 14
          ),
        ),
      ),
    );
  }

  Widget _createArticleContentItem(ArticleDetailsModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          model.content,
          style: const TextStyle(
              fontSize: 14
          ),
        ),
      ),
    );
  }

  Widget _createArticlePublishedDateItem(ArticleDetailsModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          model.content,
          style: const TextStyle(
              fontSize: 14
          ),
        ),
      ),
    );
  }
}
