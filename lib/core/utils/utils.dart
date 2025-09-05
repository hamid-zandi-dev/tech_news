import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1, milliseconds: 200),
      content: Text(message),
    ));
  }

  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static void changeStatusBarAndNavigationBarColor(
      Color statusBar, Color navigationBar) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBar,
      systemNavigationBarColor: navigationBar,
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ));
  }

  static ThemeType getThemeByName(String themeName) {
    return ThemeType.values.byName(themeName);
  }

  static getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static int getTotalPages(int items, int pageLimit) {
    if (items > 0) {
      final totalPages = (items.toDouble() / pageLimit).ceil();
      return totalPages;
    }
    return 0;
  }

  static Future<bool> checkInternet() async {
    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 3);
      dio.options.receiveTimeout = const Duration(seconds: 3);

      // Use a single, reliable endpoint
      final response = await dio.head('https://www.cloudflare.com');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  /// Quick network connectivity check with shorter timeout
  static Future<bool> quickNetworkCheck() async {
    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 3);
      dio.options.receiveTimeout = const Duration(seconds: 3);

      final response = await dio.head('https://www.cloudflare.com');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}

/// Simple logging utility
class Logger {
  static void log(String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag]' : '';
    print('📱 $tagStr $timestamp: $message');
  }

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      log(message, tag: tag);
    }
  }

  static void error(String message, {String? tag, Object? error}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag]' : '';
    final errorStr = error != null ? ' - Error: $error' : '';
    print('❌ $tagStr $timestamp: $message$errorStr');
  }
}
