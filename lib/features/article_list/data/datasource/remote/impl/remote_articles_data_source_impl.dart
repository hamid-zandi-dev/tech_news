import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tech_news/core/error_handling/custom_exception.dart';
import 'package:tech_news/core/utils/Constants.dart';
import 'package:tech_news/core/utils/utils.dart';
import 'package:tech_news/features/article_list/data/datasource/remote/abstraction/remote_articles_data_source.dart';
import 'package:tech_news/features/article_list/data/datasource/remote/dto/articles_dto.dart';

class RemoteArticlesDataSourceImpl implements RemoteArticlesDataSource {
  final Dio _dio;
  RemoteArticlesDataSourceImpl(this._dio);

  @override
  Future<ArticlesDto> getArticles(
      {required String query,
      required String from,
      required String to,
      required int page,
      required int pageSize}) async {
    try {
      Logger.debug('Making API request for query: $query, page: $page',
          tag: 'RemoteDataSource');

      final response = await _dio.get(
        "${Constants.baseUrl}v2/everything",
        queryParameters: {
          "q": query,
          "sortBy": "publishedAt",
          "from": from,
          "to": to,
          "page": page,
          "pageSize": pageSize,
          "language": "en",
        },
        options: Options(
          headers: {
            "X-Api-Key": dotenv.env["API_KEY"],
          },
        ),
      );

      if (response.statusCode == 200) {
        Logger.debug('API request successful, status: ${response.statusCode}',
            tag: 'RemoteDataSource');
        return ArticlesDto.fromJson(response.data);
      } else {
        Logger.error('API request failed with status: ${response.statusCode}',
            tag: 'RemoteDataSource');
        throw RestApiException(response.statusCode);
      }
    } on DioException catch (e) {
      Logger.error('DioException occurred: ${e.type}', tag: 'RemoteDataSource');

      switch (e.type) {
        case DioExceptionType.connectionError:
          Logger.error('Connection error - checking internet connectivity',
              tag: 'RemoteDataSource');
          // Check if it's actually a network issue
          final hasInternet = await Utils.checkInternet();
          if (!hasInternet) {
            Logger.error('No internet connection confirmed',
                tag: 'RemoteDataSource');
            throw NoInternetConnectionException();
          } else {
            Logger.error(
                'Internet available but connection failed - server issue',
                tag: 'RemoteDataSource');
            throw RestApiException(503); // Service unavailable
          }
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          Logger.error('Timeout error: ${e.type}', tag: 'RemoteDataSource');
          throw RestApiException(408); // Request timeout
        case DioExceptionType.badResponse:
          Logger.error('Bad response: ${e.response?.statusCode}',
              tag: 'RemoteDataSource');
          throw RestApiException(e.response?.statusCode);
        case DioExceptionType.cancel:
          Logger.error('Request cancelled', tag: 'RemoteDataSource');
          throw Exception('Request was cancelled');
        default:
          Logger.error('Unknown DioException: ${e.type}',
              tag: 'RemoteDataSource');
          throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      Logger.error('Unexpected error: $e', tag: 'RemoteDataSource');
      throw Exception('Unexpected error: $e');
    }
  }
}
