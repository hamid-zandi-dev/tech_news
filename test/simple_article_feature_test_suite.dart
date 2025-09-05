import 'package:flutter_test/flutter_test.dart';

// Import all working test files
import 'features/article/domain/model/simple_article_model_test.dart'
    as article_model_test;
import 'features/article/data/repository/simple_circular_sort_test.dart'
    as circular_sort_test;
import 'features/article/presentation/widget/article_item_widget_test.dart'
    as article_item_widget_test;

void main() {
  group('Article Feature Test Suite', () {
    group('Domain Layer Tests', () {
      group('Article Model Tests', () {
        article_model_test.main();
      });
    });

    group('Data Layer Tests', () {
      group('Circular Sort Tests', () {
        circular_sort_test.main();
      });
    });

    group('Presentation Layer Tests', () {
      group('Widget Tests', () {
        article_item_widget_test.main();
      });
    });
  });
}
