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

enum ThemeType {
  light,
  dark;
}

class Dimen {
  static const double navigationBottomIconSize = 24;
  static const double iconSize = 24;
  static const double navigationBottomProfileIconSize = 24;
  static const double navigationBottomElevation = 8;
  static const int pageViewAnimationDuration = 300;
  static const int sliderIntervalDuration = 5000;
  static const int sliderAnimationDuration = 800;
  static const int splashTime = 2000;
  static const double splashFontSize = 34;
  static const double retryIconSize = 64;
  static const int debounceMilliSecondTime = 1000;
  static const double sideMargin = 1000;
  static const double searchBoxRadius = 12;
  static const double retryRadius = 8;
}


class ImagesPath {
  static const _path = "assets/images/";
  static const iconRetry2 = "${_path}ic_retry2.svg";
  static const noInternetConnectionError = "${_path}no_connection_error.png";
  static const serverError = "${_path}server_error.png";
  static const noFoundData = "${_path}empty_data_error.png";
  static const unknownError = "${_path}unknown_error.png";
  static const articlePlaceHolder = "${_path}article_placeholder.svg";
}