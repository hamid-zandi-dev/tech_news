import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_news/core/utils/shared_preferences_manager.dart';
import 'package:tech_news/features/article_list/data/datasource/local/mapper/local_article_mapper.dart';
import 'package:tech_news/features/article_list/data/datasource/remote/abstraction/articles_data_source.dart';
import 'package:tech_news/features/article_list/data/datasource/remote/impl/articles_data_source_impl.dart';
import 'package:tech_news/features/article_list/data/datasource/remote/mapper/remote_article_mapper.dart';
import 'package:tech_news/features/article_list/data/repository/articles_repository_impl.dart';
import 'package:tech_news/features/article_list/domain/repository/articles_repository.dart';
import 'package:tech_news/features/article_list/domain/usecase/get_articles_usecase.dart';
import 'package:tech_news/features/article_list/presentation/bloc/article_list_bloc.dart';

GetIt locator = GetIt.instance;

setupInjection() async {
  await provideSharedPreferences();
  provideSharedPreferencesManager(locator());
  provideDioBaseOptions();
  provideDio();

  provideArticleMappers();
  provideArticleDataSource();
  provideArticleRepository();
  provideArticleUseCases();
  provideArticleBloc();
}

Future<void> provideSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);
}

void provideSharedPreferencesManager(SharedPreferences sharedPreferences) {
  final sharedPreferencesManager = SharedPreferencesManager(sharedPreferences);
  locator.registerSingleton<SharedPreferencesManager>(sharedPreferencesManager);
}

void provideDio() {
  locator.registerFactory<Dio>(() => Dio(locator()));
}

void provideDioBaseOptions() {
  BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20)
  );
  locator.registerSingleton<BaseOptions>(options);
}

void provideArticleMappers() {
  if (!GetIt.instance.isRegistered<LocalArticleMapper>()) {
    locator.registerFactory<LocalArticleMapper>(() => LocalArticleMapper());
  }
  if (!GetIt.instance.isRegistered<RemoteArticleMapper>()) {
    locator.registerFactory<RemoteArticleMapper>(() => RemoteArticleMapper());
  }
}

void provideArticleDataSource() {
  if (!GetIt.instance.isRegistered<ArticlesDataSource>()) {
    locator.registerFactory<ArticlesDataSource>(() =>
        ArticlesDataSourceImpl(locator()));
  }
}

void provideArticleRepository() {
  if (!GetIt.instance.isRegistered<ArticlesRepository>()) {
    locator.registerFactory<ArticlesRepository>(() =>
        ArticlesRepositoryImpl(locator(), locator(), locator()));
  }
}

void provideArticleUseCases() {
  if (!GetIt.instance.isRegistered<GetArticlesUsecase>()) {
    locator.registerFactory<GetArticlesUsecase>(() =>
        GetArticlesUsecase(locator()));
  }
}

void provideArticleBloc() {
  if (!GetIt.instance.isRegistered<ArticleListBloc>()) {
    locator.registerFactory<ArticleListBloc>(() => ArticleListBloc(locator()));
  }
}



