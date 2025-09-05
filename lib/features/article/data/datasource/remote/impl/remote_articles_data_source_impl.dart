import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tech_news/core/error_handling/data/data_exception.dart';
import 'package:tech_news/core/utils/Constants.dart';
import 'package:tech_news/core/utils/utils.dart';
import 'package:tech_news/features/article/data/datasource/remote/abstraction/remote_articles_data_source.dart';
import 'package:tech_news/features/article/data/datasource/remote/dto/articles_dto.dart';

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
        throw ServerException(
          message: 'Server returned status code: ${response.statusCode}',
          code: response.statusCode.toString(),
          details: {
            'statusCode': response.statusCode,
            'response': response.data,
            'query': query,
            'page': page,
          },
        );
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
            throw NetworkException(
              message: 'No internet connection available',
              code: 'NO_INTERNET_CONNECTION',
              details: {
                'query': query,
                'page': page,
                'timestamp': DateTime.now().toIso8601String(),
              },
              originalException: e,
            );
          } else {
            Logger.error(
                'Internet available but connection failed - server issue',
                tag: 'RemoteDataSource');
            throw ServerException(
              message: 'Server is unavailable or unreachable',
              code: 'SERVER_UNAVAILABLE',
              details: {
                'query': query,
                'page': page,
                'timestamp': DateTime.now().toIso8601String(),
              },
              originalException: e,
            );
          }
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          Logger.error('Timeout error: ${e.type}', tag: 'RemoteDataSource');
          throw TimeoutException(
            message: 'Request timeout occurred',
            code: 'REQUEST_TIMEOUT',
            details: {
              'timeoutType': e.type.toString(),
              'query': query,
              'page': page,
              'timestamp': DateTime.now().toIso8601String(),
            },
            originalException: e,
          );
        case DioExceptionType.badResponse:
          Logger.error('Bad response: ${e.response?.statusCode}',
              tag: 'RemoteDataSource');
          final statusCode = e.response?.statusCode ?? 0;
          if (statusCode >= 400 && statusCode < 500) {
            throw ValidationException(
              message:
                  'Client error: ${e.response?.statusMessage ?? 'Bad request'}',
              code: statusCode.toString(),
              details: {
                'statusCode': statusCode,
                'response': e.response?.data,
                'query': query,
                'page': page,
              },
              originalException: e,
            );
          } else {
            throw ServerException(
              message:
                  'Server error: ${e.response?.statusMessage ?? 'Internal server error'}',
              code: statusCode.toString(),
              details: {
                'statusCode': statusCode,
                'response': e.response?.data,
                'query': query,
                'page': page,
              },
              originalException: e,
            );
          }
        case DioExceptionType.cancel:
          Logger.error('Request cancelled', tag: 'RemoteDataSource');
          throw NetworkException(
            message: 'Request was cancelled',
            code: 'REQUEST_CANCELLED',
            details: {
              'query': query,
              'page': page,
              'timestamp': DateTime.now().toIso8601String(),
            },
            originalException: e,
          );
        default:
          Logger.error('Unknown DioException: ${e.type}',
              tag: 'RemoteDataSource');
          throw UnknownException(
            message: 'Unknown network error occurred',
            code: 'UNKNOWN_NETWORK_ERROR',
            details: {
              'dioExceptionType': e.type.toString(),
              'message': e.message,
              'query': query,
              'page': page,
            },
            originalException: e,
          );
      }
    } catch (e) {
      Logger.error('Unexpected error: $e', tag: 'RemoteDataSource');
      if (e is DataException) {
        rethrow; // Re-throw if it's already a DataException
      }
      throw UnknownException(
        message: 'Unexpected error occurred: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
        details: {
          'error': e.toString(),
          'query': query,
          'page': page,
          'timestamp': DateTime.now().toIso8601String(),
        },
        originalException: e is Exception ? e : null,
      );
    }
  }
}
