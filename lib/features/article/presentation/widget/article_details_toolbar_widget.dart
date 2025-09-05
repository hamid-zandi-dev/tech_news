import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech_news/core/theme/theme_manager.dart';
import 'package:tech_news/core/utils/constants.dart';
import 'package:tech_news/core/utils/utils.dart';

class ArticleDetailsToolbarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final String image;
  final Function()? onBackButtonClickListener;
  final Function(bool isBookmark)? onBookmarkButtonClickListener;

  const ArticleDetailsToolbarWidget({
    super.key,
    required this.title,
    required this.image,
    this.onBackButtonClickListener,
    this.onBookmarkButtonClickListener,
  });

  @override
  State<ArticleDetailsToolbarWidget> createState() =>
      _ArticleDetailsToolbarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _ArticleDetailsToolbarWidgetState
    extends State<ArticleDetailsToolbarWidget> {
  double height = 0;
  late AppColor _appColor;

  @override
  Widget build(BuildContext context) {
    _appColor = Theme.of(context).extension<AppColor>()!;
    height = (Utils.getWidth(context) * 3) / 4;
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      excludeHeaderSemantics: true,
      expandedHeight: height,
      backgroundColor: _appColor.primaryColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // For Android (light icons)
        statusBarBrightness: Brightness.dark, // For iOS (light icons)
      ),
      leading: _createBackButton(),
      flexibleSpace: _createFlexibleSpaceBar(),
    );
  }

  Widget _createFlexibleSpaceBar() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double currentHeightOffset = 0;
        if (height > 0) {
          currentHeightOffset = constraints.biggest.height / height;
        }
        return FlexibleSpaceBar(
          titlePadding: const EdgeInsets.fromLTRB(60, 0, 60, 18),
          stretchModes: const [
            StretchMode.zoomBackground,
          ],
          centerTitle: true,
          collapseMode: CollapseMode.pin,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (currentHeightOffset <= 0.5)
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    widget.title,
                    style: TextStyle(
                        color: _appColor.tintOnPrimaryColor, fontSize: 16),
                  ),
                ),
            ],
          ),
          background: _createToolbarBackground(),
        );
      },
    );
  }

  Widget _createToolbarBackground() {
    if (widget.image.isEmpty) {
      return _createRecipeHolderWidget();
    } else {
      return CachedNetworkImage(
        imageUrl: widget.image,
        imageBuilder: (context, imageProvider) =>
            _createLoadedNetworkImageWidget(imageProvider),
        placeholder: (context, url) => _createRecipeHolderWidget(),
        errorWidget: (context, url, error) => _createRecipeHolderWidget(),
      );
    }
  }

  Widget _createLoadedNetworkImageWidget(ImageProvider<Object> imageProvider) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Image(
        image: imageProvider,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _createRecipeHolderWidget() {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        color: _appColor.placeHolderBackgroundColor,
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
              return SvgPicture.asset(
                width: boxConstraints.biggest.height / 2,
                height: boxConstraints.biggest.height / 2,
                fit: BoxFit.cover,
                ImagesPath.articlePlaceHolder,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _createBackButton() {
    return IconButton(
      color: _appColor.tintOnPrimaryColor,
      icon: const Icon(
        Icons.arrow_back,
        size: Dimen.iconSize,
      ),
      onPressed: () {
        if (widget.onBackButtonClickListener != null) {
          widget.onBackButtonClickListener!();
        }
      },
    );
  }
}
