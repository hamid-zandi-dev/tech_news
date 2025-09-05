import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech_news/core/utils/Constants.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleItemWidget extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  final String nameOfQuery;
  final String date;
  final Function()? onClickListener;
  const ArticleItemWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.description,
      required this.nameOfQuery,
      required this.date,
      this.onClickListener});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          if (onClickListener != null) {
            onClickListener!();
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              _createImage(),
              // Company name badge at top center
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    nameOfQuery,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black45,
                      Colors.transparent,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(0.0, 1),
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createImage() {
    if (image.isEmpty) {
      return _createPlaceHolderAndErrorWidget();
    } else {
      return Stack(
        children: [
          _createPlaceHolderAndErrorWidget(),
          CachedNetworkImage(
            imageUrl: image,
            imageBuilder: (context, imageProvider) =>
                _createLoadedNetworkImage(imageProvider),
            placeholder: (context, url) => _createPlaceHolderAndErrorWidget(),
            errorWidget: (context, url, error) =>
                _createPlaceHolderAndErrorWidget(),
          )
        ],
      );
    }
  }

  Widget _createLoadedNetworkImage(ImageProvider<Object> imageProvider) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Ink(
        child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: imageProvider,
            fit: BoxFit.cover),
      ),
    );
  }

  Widget _createPlaceHolderAndErrorWidget() {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Center(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
          return SvgPicture.asset(
            width: boxConstraints.biggest.width / 2.5,
            height: boxConstraints.biggest.width / 2.5,
            fit: BoxFit.cover,
            ImagesPath.articlePlaceHolder,
          );
        }),
      ),
    );
  }
}
