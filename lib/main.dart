import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tech_news/features/article_details/presentation/screen/article_details_screen.dart';
import 'package:tech_news/features/article_list/presentation/screen/article_list_screen.dart';
import 'core/color/colors.dart';
import 'core/di/locator.dart';
import 'core/theme/theme_manager.dart';
import 'core/utils/constants.dart';
import 'core/utils/shared_preferences_manager.dart';
import 'core/utils/utils.dart';
import 'features/article_list/presentation/bloc/article_list_bloc.dart';

SharedPreferencesManager sharedPreferencesManager = locator();
late ThemeManager _themeManager;
ThemeType themeType = ThemeType.light;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable logging
  Logger.log('App starting', tag: 'Main');

  // Test logging functionality
  Logger.debug('Debug logging is working', tag: 'Main');
  Logger.error('Error logging is working', tag: 'Main');

  await dotenv.load(fileName: ".env");
  await setupInjection();
  _setupThemeManager();

  Logger.log('App initialization completed', tag: 'Main');

  runApp(const MyApp());
}

void _setupThemeManager() {
  String? locale = sharedPreferencesManager.getCurrentLanguage();
  String font = _getFont(locale ?? Locales.kurdishLocale.locale);

  HashMap<ThemeType, CustomColor> hashMap = HashMap();
  hashMap.putIfAbsent(ThemeType.light, () => LightColor());
  hashMap.putIfAbsent(ThemeType.dark, () => DarkColor());
  _themeManager = ThemeManager(hashMap, font);
}

ThemeType _getCurrentTheme() {
  String currentThemeName =
      sharedPreferencesManager.getCurrentTheme() ?? ThemeType.light.name;
  ThemeType themeType;
  try {
    themeType = Utils.getThemeByName(currentThemeName);
  } catch (e) {
    themeType = ThemeType.light;
  }
  return themeType;
}

String _getFont(String locale) {
  String font = FontFamily.iranSans.font;
  if (locale == Locales.persianLocale.locale) {
    font = FontFamily.iranSans.font;
  } else {
    font = FontFamily.openSans.font;
  }
  return font;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech News',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.articleListRoute,
      theme: _themeManager.getTheme(_getCurrentTheme()),
      routes: {
        AppRoutes.articleListRoute: (context) => BlocProvider(
              create: (context) => locator<ArticleListBloc>(),
              child: const ArticleListScreen(),
            ),
        AppRoutes.articleDetailsRoute: (context) =>
            const ArticleDetailsScreen(),
      },
      locale: Locale(Locales.englishLocale.locale),
      builder: (context, child) {
        // Add network status indicator in debug mode
        if (kDebugMode) {
          return FutureBuilder<bool>(
            future: Utils.quickNetworkCheck(),
            builder: (context, snapshot) {
              final hasInternet = snapshot.data ?? false;
              final status = hasInternet ? '🟢' : '🔴';
              Logger.debug(
                  'Network status: ${hasInternet ? 'Connected' : 'Disconnected'}',
                  tag: 'Main');

              return Scaffold(
                appBar: AppBar(
                  title: Text('Tech News $status'),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                body: child!,
              );
            },
          );
        }
        return child!;
      },
    );
  }
}
