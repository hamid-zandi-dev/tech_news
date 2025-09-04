import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tech_news/features/article_details/presentation/screen/article_details_screen.dart';
import 'package:tech_news/features/article_list/presentation/screen/article_list_screen.dart';
import 'core/color/colors.dart';
import 'core/di/locator.dart';
import 'core/theme/theme_manager.dart';
import 'core/utils/constants.dart';
import 'core/utils/shared_preferences_manager.dart';
import 'core/utils/utils.dart';

SharedPreferencesManager sharedPreferencesManager = locator();
late ThemeManager _themeManager;
ThemeType themeType = ThemeType.light;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  _setupThemeManager();
  runApp(const MyApp());
  // final appDatabase = await $FloorAppDatabase
  //     .databaseBuilder("app_database.db").build();
  // runApp(
  //   ProviderScope(
  //     overrides: [
  //       databaseProvider.overrideWithValue(appDatabase),
  //     ],
  //     child: const MyApp(),
  //   ),
  // );
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
  String currentThemeName = sharedPreferencesManager.getCurrentTheme() ?? ThemeType.light.name;
  ThemeType themeType;
  try {
    themeType = Utils.getThemeByName(currentThemeName);
  }
  catch (e) {
    themeType = ThemeType.light;
  }
  return themeType;
}

String _getFont(String locale) {
  String font = FontFamily.iranSans.font;
  if (locale == Locales.persianLocale.locale) {
    font = FontFamily.iranSans.font;
  }
  else {
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
        AppRoutes.articleListRoute: (context)=> const ArticleListScreen(),
        AppRoutes.articleDetailsRoute: (context)=> const ArticleDetailsScreen(),
      },
      locale: Locale(Locales.englishLocale.locale),
    );
  }
}
