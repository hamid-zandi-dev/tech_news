import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_manager.dart';

class ToolbarWidget extends StatefulWidget implements PreferredSizeWidget{
  final Color? toolbarColor;
  final String title;
  final void Function()? onBackButtonClickListener;
  const ToolbarWidget({
    super.key,
    this.toolbarColor,
    this.title = "",
    this.onBackButtonClickListener,
  });

  @override
  State<ToolbarWidget> createState() => _ToolbarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _ToolbarWidgetState extends State<ToolbarWidget> {
  late AppColor _appColor;
  @override
  Widget build(BuildContext context) {
    _appColor = Theme.of(context).extension<AppColor>()!;
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: widget.toolbarColor ?? _appColor.primaryColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: widget.toolbarColor ?? _appColor.primaryColor,
        statusBarIconBrightness: Brightness.light, // For Android (light icons)
        statusBarBrightness: Brightness.dark, // For iOS (light icons)
      ),
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 16),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (widget.onBackButtonClickListener != null) {
            widget.onBackButtonClickListener!();
          }
        },
      ),
    );
  }
}
