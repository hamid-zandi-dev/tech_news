class Constants {
  static const baseUrl = "https://newsapi.org/";
  static const articlesLimit = 20;
  static const defaultLanguage = "en";
}

class SharedPreferencesKeys {
  static const currentTheme = "CurrentTheme";
  static const currentLanguage = "CurrentLanguage";
  static const currentFont = "CurrentFont";
  static const isSelectedLanguageForFirstTime = "IsSelectedLanguageForFirstTime";
}

class RestApiError {
  static const int fromServerError = 500;
  static const int toServerError = 599;
}