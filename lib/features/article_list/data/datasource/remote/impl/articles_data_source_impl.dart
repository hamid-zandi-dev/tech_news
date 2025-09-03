import 'package:dio/dio.dart';
import 'package:tech_news/core/error_handling/custom_exception.dart';
import 'package:tech_news/core/utils/Constants.dart';
import 'package:tech_news/features/article_list/data/datasource/remote/abstraction/articles_data_source.dart';
import 'package:tech_news/features/article_list/data/datasource/remote/dto/articles_dto.dart';

class ArticlesDataSourceImpl implements ArticlesDataSource {
  final Dio _dio;
  ArticlesDataSourceImpl(this._dio);

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