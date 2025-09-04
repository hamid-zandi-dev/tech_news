import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_news/core/di/locator.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/theme/theme_manager.dart';
import 'package:tech_news/core/widget/circular_progress_bar_widget.dart';
import 'package:tech_news/core/widget/error_handling/error_handling_factory_widget.dart';
import 'package:tech_news/core/widget/non_scrollable_refresh_indicator_widget.dart';
import 'package:tech_news/core/widget/toolbar_widget.dart';
import 'package:tech_news/features/article_details/domain/model/article_details_model.dart';
import 'package:tech_news/features/article_details/presentation/widget/article_details_info_widget.dart';

import '../bloc/article_details_bloc.dart';
import '../bloc/article_details_status.dart';
import '../widget/article_details_toolbar_widget.dart';

class ArticleDetailsScreen extends StatefulWidget {
  static const String articleId = "articleId";

  const ArticleDetailsScreen({super.key});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => locator<ArticleDetailsBloc>(),
      child: const ArticleDetailsChildScreen(),
    );
  }
}

class ArticleDetailsChildScreen extends StatefulWidget {
  const ArticleDetailsChildScreen({super.key});

  @override
  State<ArticleDetailsChildScreen> createState() => _ArticleDetailsChildScreenState();
}

class _ArticleDetailsChildScreenState extends State<ArticleDetailsChildScreen> {
  String _articleId = "";
  late AppColor _appColor;

  @override
  void initState() {
    super.initState();
    onWidgetCreated();
  }

  void onWidgetCreated() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      initArguments();
      _callGetArticleDetailsEvent();
    });
  }

  void initArguments() {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    var value = arguments[ArticleDetailsScreen.articleId];
    if (value is String) {
      _articleId = value;
    }
  }

  void _callGetArticleDetailsEvent() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ArticleDetailsBloc>(context).add(GetArticleDetailsEvent(_articleId.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    _appColor = Theme.of(context).extension<AppColor>()!;
    return _getArticleDetails();
  }

  Widget _getArticleDetails() {
    return BlocBuilder<ArticleDetailsBloc, ArticleDetailsState>(
      buildWhen: (previous, current) {
        if (current is GetArticleDetailsState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is GetArticleDetailsState) {
          if (state.articleDetailsStatus is ArticleDetailsLoadingStatus) {
            return _createLoadingWidget();
          }
          else if (state.articleDetailsStatus is ArticleDetailsLoadedStatus) {
            final ArticleDetailsLoadedStatus articleDetailsLoadedStatus = state.articleDetailsStatus as ArticleDetailsLoadedStatus;
            final ArticleDetailsModel articleDetailsModel = articleDetailsLoadedStatus.articleDetailsModel;
            return _createLoadedWidget(context, articleDetailsModel);
          }
          else if (state.articleDetailsStatus is ArticleDetailsErrorStatus) {
            ArticleDetailsErrorStatus articleDetailsErrorStatus = state.articleDetailsStatus as ArticleDetailsErrorStatus;
            return _createErrorHandlingWidget(articleDetailsErrorStatus.failure);
          }
          return _createLoadingWidget();
        }
        return _createLoadingWidget();
      },
    );
  }

  Widget _createLoadingWidget() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ToolbarWidget(
        onBackButtonClickListener: () {
          Navigator.of(context).pop();
        },
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: CircularProgressBarWidget(color: _appColor.primaryColor),
        ),
      ),
    );
  }

  Widget _createErrorHandlingWidget(Failure failure) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ToolbarWidget(
        onBackButtonClickListener: () {
          Navigator.of(context).pop();
        },
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: NonScrollableRefreshIndicatorWidget(
          onRefresh: () async {
            _callGetArticleDetailsEvent();
          },
          child: ErrorHandlingFactoryWidget(context, failure, onClickListener: () {
            _callGetArticleDetailsEvent();
          }),
        ),
      ),
    );
  }

  Widget _createLoadedWidget(BuildContext context, ArticleDetailsModel articleDetailsModel) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CustomScrollView(
          slivers: <Widget>[
            _createToolbarWidget(articleDetailsModel),
            _createBodyWidget(articleDetailsModel),
          ],
        ),
      ),
    );
  }

  Widget _createToolbarWidget(ArticleDetailsModel articleDetailsModel) {
    return ArticleDetailsToolbarWidget(
      title: "",
      image: articleDetailsModel.urlToImage,
      onBackButtonClickListener: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _createBodyWidget(ArticleDetailsModel articleDetailsModel) {
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
              const SizedBox(height: 16,),
              Divider(
                thickness: 2,
                color: _appColor.borderColor,
              ),
              ArticleDetailsInfoWidget(articleDetailsModel: articleDetailsModel)
            ],
          ),
        ),
      ),
    );
  }
}

