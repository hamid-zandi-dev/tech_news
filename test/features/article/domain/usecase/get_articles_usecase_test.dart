import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news/core/error_handling/domain/failure.dart';
import 'package:tech_news/features/article/domain/model/article_model.dart';
import 'package:tech_news/features/article/domain/model/article_source_model.dart';
import 'package:tech_news/features/article/domain/repository/articles_repository.dart';
import 'package:tech_news/features/article/domain/usecase/get_articles_usecase.dart';

class _FakeArticlesRepository implements ArticlesRepository {
  Params? lastParams;
  final StreamController<Either<Failure, List<ArticleModel>>> _controller =
      StreamController<Either<Failure, List<ArticleModel>>>.broadcast();

  @override
  Stream<Either<Failure, List<ArticleModel>>> getArticles(Params params) {
    lastParams = params;
    return _controller.stream;
  }

  void addSuccess(List<ArticleModel> data) {
    _controller.add(right(data));
  }

  void addFailure(Failure failure) {
    _controller.add(left(failure));
  }

  Future<void> close() async {
    await _controller.close();
  }
}

void main() {
  group('GetArticlesUsecase', () {
    late _FakeArticlesRepository repository;
    late GetArticlesUsecase usecase;

    setUp(() {
      repository = _FakeArticlesRepository();
      usecase = GetArticlesUsecase(repository);
    });

    tearDown(() async {
      await repository.close();
    });

    test('forwards params to repository', () async {
      final params = GetArticlesParams.forQuery(
        'Microsoft OR Apple',
        '2025-09-15T11:05:11Z',
        '2025-09-13T11:05:11Z',
        1,
        20,
      );

      // Act: subscribe to the stream
      final stream = usecase(params);

      // Trigger an emission to ensure repository was invoked
      final sampleArticle = ArticleModel(
        source: ArticleSourceModel(id: 'id', name: 'name'),
        title: 't',
        queryTitle: 'Microsoft',
      );
      repository.addSuccess([sampleArticle]);

      // Consume one event to avoid unhandled stream
      await stream.first;

      // Assert
      expect(repository.lastParams, isNotNull);
      expect(repository.lastParams!.query, equals('Microsoft OR Apple'));
      expect(repository.lastParams!.to, equals('2025-09-15T11:05:11Z'));
      expect(repository.lastParams!.from, equals('2025-09-13T11:05:11Z'));
      expect(repository.lastParams!.page, equals(1));
      expect(repository.lastParams!.pageSize, equals(20));
    });

    test('emits success from repository stream', () async {
      final params = GetArticlesParams.forQuery(
        'Q',
        'T',
        'F',
        1,
        10,
      );

      final stream = usecase(params);

      final sample = ArticleModel(
        source: ArticleSourceModel(id: 'id', name: 'name'),
        title: 'title',
        queryTitle: 'Microsoft',
      );

      // Schedule async success
      Future.microtask(() => repository.addSuccess([sample]));

      final result = await stream.first;

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right but got Left'),
        (list) {
          expect(list, hasLength(1));
          expect(list.first.title, equals('title'));
        },
      );
    });

    test('emits failure from repository stream', () async {
      final params = GetArticlesParams.forQuery('Q', 'T', 'F', 1, 10);
      final stream = usecase(params);

      final failure = UnknownFailure(message: 'boom');
      Future.microtask(() => repository.addFailure(failure));

      final result = await stream.first;

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, equals(failure)),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}
