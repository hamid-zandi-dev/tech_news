import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'features/article/data/repository/circular_sort_test.dart'
    as circular_sort_test;
import 'features/article/domain/model/article_model_test.dart'
    as article_model_test;
import 'features/article/domain/usecase/get_articles_usecase_test.dart'
    as get_articles_usecase_test;
import 'features/article/presentation/bloc/article_list_bloc_test.dart'
    as article_list_bloc_test;
import 'features/article/data/repository/articles_repository_test.dart'
    as articles_repository_test;
import 'features/article/presentation/widget/article_item_widget_test.dart'
    as article_item_widget_test;

void main() {
  group('Article Feature Test Suite', () {
    group('Data Layer Tests', () {
      group('Circular Sort Tests', () {
        circular_sort_test.main();
      });

      group('Repository Tests', () {
        articles_repository_test.main();
      });
    });

    group('Domain Layer Tests', () {
      group('Article Model Tests', () {
        article_model_test.main();
      });

      group('Use Case Tests', () {
        get_articles_usecase_test.main();
      });
    });

    group('Presentation Layer Tests', () {
      group('Bloc Tests', () {
        article_list_bloc_test.main();
      });

      group('Widget Tests', () {
        article_item_widget_test.main();
      });
    });
  });
}
