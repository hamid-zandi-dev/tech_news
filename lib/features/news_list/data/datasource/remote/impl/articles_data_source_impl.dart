import 'package:dio/dio.dart';
import 'package:net_xatun_social/core/data/datasource/network/dto/recipes_dto.dart';
import 'package:net_xatun_social/core/error_handling/custom_exception.dart';
import 'package:net_xatun_social/core/extension/dio_extension.dart';
import 'package:net_xatun_social/features/feature_search/data/datasource/network/abstraction/search_recipe_data_source.dart';
import 'package:net_xatun_social/core/utils/constants.dart';
import 'package:tech_news/core/error_handling/custom_exception.dart';
import 'package:tech_news/core/utils/Constants.dart';
import 'package:tech_news/features/news_list/data/datasource/remote/abstraction/articles_data_source.dart';
import 'package:tech_news/features/news_list/data/datasource/remote/dto/article_dto.dart';
import 'package:tech_news/features/news_list/data/datasource/remote/dto/articles_dto.dart';

class ArticlesDataSourceImpl implements ArticlesDataSource {
  final Dio _dio;
  SearchRecipeDataSourceImpl(this._dio);

  @override
  Future<RecipesDTO> getRecipes(String recipeName, int page, String lang) async {
    try {
      final response = await _dio.get("${Constants.baseUrl}v1/recipes/search-recipe-paging",
          queryParameters: {
            "recipe_name": recipeName,
            "page": page,
            "size": Constants.recipesLimit
          },
          options: Options(
            headers: {"lang": lang},
          )
      );

      if (response.statusCode == 200) {
        return RecipesDTO.fromJson(response.data);
      } else {
        throw RestApiException(response.statusCode);
      }
    }
    on DioError catch (e) {
      if (e.isNoConnectionError) {
        throw NoInternetConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        throw Exception(e);
      }
    }
  }

  @override
  Future<ArticlesDto> getArticles(String query, int page) async {
    try {
      final response = await _dio.get("${Constants.baseUrl}v2/everything",
          queryParameters: {
            "q": query,
            "sortBy": "publishedAt",
            "page": page,
            "pageSize": Constants.articlesLimit,
            "apiKey": "ed1afab45e8f4e4692f75f2834e120d8"
          },
      );

      if (response.statusCode == 200) {
        return ArticlesDto.fromJson(response.data);
      } else {
        throw RestApiException(response.statusCode);
      }
    }
    on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw NoInternetConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        throw Exception(e);
      }
    }
  }
}