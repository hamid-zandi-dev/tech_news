import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_news/core/di/locator.dart';
import 'package:tech_news/core/error_handling/failure.dart';
import 'package:tech_news/core/theme/theme_manager.dart';
import 'package:tech_news/core/utils/Constants.dart';
import 'package:tech_news/core/widget/circular_progress_bar_widget.dart';
import 'package:tech_news/core/widget/error_handling/error_handling_factory_widget.dart';
import 'package:tech_news/core/widget/non_scrollable_refresh_indicator_widget.dart';
import 'package:tech_news/features/article_details/presentation/screen/article_details_screen.dart';
import 'package:tech_news/features/article_list/presentation/bloc/article_list_status.dart';
import 'package:tech_news/features/article_list/presentation/widget/article_item_widget.dart';
import '../../domain/model/article_model.dart';
import '../bloc/article_list_bloc.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> with AutomaticKeepAliveClientMixin<ArticleListScreen> {
  List<ArticleModel> list = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  late AppColor _appColor;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _appColor = Theme.of(context).extension<AppColor>()!;
    return _createFavoriteRecipesResultWidget();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onWidgetCreated();
    });
  }

  void onWidgetCreated() {
    refreshScreen();
    setOnScrollChangeListener();
  }

  void callInitialEvent() {
    BlocProvider.of<ArticleListBloc>(context).add(PageToInitial());
  }

  void callGetArticleListEvent() {
    _isLoading = true;
    BlocProvider.of<ArticleListBloc>(context).add(GetArticleListEvent());
  }

  void refreshScreen() {
    callInitialEvent();
    callGetArticleListEvent();
  }

  void setOnScrollChangeListener() {
    _scrollController.addListener(() {
      if (!_isLoading && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        callGetArticleListEvent();
      }
    });
  }

  _createFavoriteRecipesResultWidget() {
    return BlocBuilder<ArticleListBloc, ArticleListState>(
      buildWhen: (previous, current) {
        if (current is GetArticleListState) {
          return true;
        }
        return false;
      },
      builder: (BuildContext context, state) {
        if (state is GetArticleListState) {
          Widget widget = Container();
          bool isLoadingMore = false;
          if (state.articleListStatus is ArticleListLoadingStatus) {
            _isLoading = true;
            widget = _createLoadingWidget();
          }
          else if (state.articleListStatus is ArticleListEmptyStatus) {
            _isLoading = false;
            widget = _createEmptyWidget();
          }
          else if (state.articleListStatus is ArticleListLoadingMoreStatus) {
            _isLoading = true;
            widget = _createLoadedWidget(list);
            isLoadingMore = true;
          }
          else if (state.articleListStatus is ArticleListLoadedStatus) {
            ArticleListLoadedStatus loadedStatus = state.articleListStatus as ArticleListLoadedStatus;
            list = loadedStatus.list;
            _isLoading = false;
            widget = _createLoadedWidget(list);
            _callManualLoadingMoreItems();
          }
          else if (state.articleListStatus is ArticleListErrorStatus) {
            ArticleListErrorStatus favoriteRecipesErrorStatus = state.articleListStatus as ArticleListErrorStatus;
            _isLoading = false;
            widget = _createErrorHandlingWidget(favoriteRecipesErrorStatus.failure);
          }
          else if (state.articleListStatus is ArticleListLoadedMoreErrorStatus) {
            _isLoading = false;
            widget = _createLoadedWidget(list);
          }
          return Column(
            children: [
              Expanded(child: widget),
              Visibility(
                  visible: isLoadingMore,
                  child: _createLoadMoreIndicator()
              )
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _createEmptyWidget() {
    return _createErrorHandlingWidget(Failure.noFoundData);
  }

  Widget _createLoadingWidget() {
    return Center(
      child: CircularProgressBarWidget(
          color: _appColor.primaryColor),
    );
  }

  Widget _createLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircularProgressBarWidget(
          color: _appColor.primaryColor
      ),
    );
  }

  Widget _createErrorHandlingWidget(Failure failure) {
    return _createNonScrollableRefreshIndicatorWidget(
      widget: ErrorHandlingFactoryWidget(context, failure, onClickListener:(){
        refreshScreen();
      }),
    );
  }

  Widget _createLoadedWidget(List<ArticleModel> list) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshScreen();
      },
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return ArticleItemWidget(
            title: list[index].title,
            image: list[index].urlToImage,
            description: list[index].description,
            nameOfQuery: list[index].author,
            date: list[index].publishedAt,
            onClickListener: () {
              _handleArticleClickListener(list[index].id);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 8,
          );
        },
        itemCount: list.length,
      ),
    );
  }

  void _handleArticleClickListener(int? articleId) {
    if(articleId == null) {
      return;
    }
    Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.articleDetailsRoute,
        arguments: {
          ArticleDetailsScreen.articleId: articleId
        }
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _createNonScrollableRefreshIndicatorWidget({required Widget widget}) {
    return NonScrollableRefreshIndicatorWidget(
        onRefresh: () async {
          refreshScreen();
        },
        child: widget
    );
  }

  /// call loading more if height of list not reached to the bottom of screen.
  /// because [_scrollController] not trigger until scroll event has been occurred.
  void _callManualLoadingMoreItems() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent <= 0) {
          callGetArticleListEvent();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

}

