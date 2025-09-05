import 'package:flutter/material.dart';
import 'package:tech_news/core/theme/theme_manager.dart';
import 'package:tech_news/features/article/domain/model/article_model.dart';
import 'package:tech_news/features/article/presentation/widget/article_details_info_widget.dart';
import '../widget/article_details_toolbar_widget.dart';

class ArticleDetailsScreen extends StatefulWidget {
  static const String articleModel = "articleModel";

  const ArticleDetailsScreen({super.key});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  ArticleModel? _articleModel;
  late AppColor _appColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initArguments();
  }

  void _initArguments() {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _articleModel =
        arguments[ArticleDetailsScreen.articleModel] as ArticleModel?;
  }

  @override
  Widget build(BuildContext context) {
    _appColor = Theme.of(context).extension<AppColor>()!;

    if (_articleModel == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Article Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Text('No article data available'),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CustomScrollView(
          slivers: <Widget>[
            _createToolbarWidget(_articleModel!),
            _createBodyWidget(_articleModel!),
          ],
        ),
      ),
    );
  }

  Widget _createToolbarWidget(ArticleModel articleModel) {
    return ArticleDetailsToolbarWidget(
      title: "",
      image: articleModel.urlToImage,
      onBackButtonClickListener: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _createBodyWidget(ArticleModel articleModel) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 16,
              ),
              Divider(
                thickness: 2,
                color: _appColor.borderColor,
              ),
              ArticleDetailsInfoWidget(articleModel: articleModel)
            ],
          ),
        ),
      ),
    );
  }
}
