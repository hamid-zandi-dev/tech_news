import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news/features/article/domain/model/article_model.dart';
import 'package:tech_news/features/article/domain/model/article_source_model.dart';

void main() {
  group('Circular Sort Algorithm Tests', () {
    late List<ArticleModel> testArticles;

    setUp(() {
      // Create test articles with different companies
      testArticles = [
        ArticleModel(
          id: 1,
          source: ArticleSourceModel(id: "1", name: "Source 1"),
          title: "Microsoft Article 1",
          queryTitle: "Microsoft",
        ),
        ArticleModel(
          id: 2,
          source: ArticleSourceModel(id: "2", name: "Source 2"),
          title: "Microsoft Article 2",
          queryTitle: "Microsoft",
        ),
        ArticleModel(
          id: 3,
          source: ArticleSourceModel(id: "3", name: "Source 3"),
          title: "Apple Article 1",
          queryTitle: "Apple",
        ),
        ArticleModel(
          id: 4,
          source: ArticleSourceModel(id: "4", name: "Source 4"),
          title: "Apple Article 2",
          queryTitle: "Apple",
        ),
        ArticleModel(
          id: 5,
          source: ArticleSourceModel(id: "5", name: "Source 5"),
          title: "Google Article 1",
          queryTitle: "Google",
        ),
        ArticleModel(
          id: 6,
          source: ArticleSourceModel(id: "6", name: "Source 6"),
          title: "Tesla Article 1",
          queryTitle: "Tesla",
        ),
      ];
    });

    test('should distribute articles in round-robin fashion', () {
      // Simulate the circular sort algorithm
      final sortedArticles = _circularSortArticles(testArticles);

      // Verify the order follows round-robin pattern
      expect(sortedArticles[0].queryTitle, equals("Microsoft"));
      expect(sortedArticles[1].queryTitle, equals("Apple"));
      expect(sortedArticles[2].queryTitle, equals("Google"));
      expect(sortedArticles[3].queryTitle, equals("Tesla"));
      expect(sortedArticles[4].queryTitle, equals("Microsoft"));
      expect(sortedArticles[5].queryTitle, equals("Apple"));
    });

    test('should handle uneven distribution of articles', () {
      // Create articles with uneven distribution
      final unevenArticles = [
        ArticleModel(
          id: 1,
          source: ArticleSourceModel(id: "1", name: "Source 1"),
          title: "Microsoft Article 1",
          queryTitle: "Microsoft",
        ),
        ArticleModel(
          id: 2,
          source: ArticleSourceModel(id: "2", name: "Source 2"),
          title: "Microsoft Article 2",
          queryTitle: "Microsoft",
        ),
        ArticleModel(
          id: 3,
          source: ArticleSourceModel(id: "3", name: "Source 3"),
          title: "Microsoft Article 3",
          queryTitle: "Microsoft",
        ),
        ArticleModel(
          id: 4,
          source: ArticleSourceModel(id: "4", name: "Source 4"),
          title: "Apple Article 1",
          queryTitle: "Apple",
        ),
      ];

      final sortedArticles = _circularSortArticles(unevenArticles);

      // Should still follow round-robin pattern
      expect(sortedArticles[0].queryTitle, equals("Microsoft"));
      expect(sortedArticles[1].queryTitle, equals("Apple"));
      expect(sortedArticles[2].queryTitle, equals("Microsoft"));
      expect(sortedArticles[3].queryTitle, equals("Microsoft"));
    });

    test('should handle empty list', () {
      final sortedArticles = _circularSortArticles([]);
      expect(sortedArticles, isEmpty);
    });

    test('should handle single company articles', () {
      final singleCompanyArticles = [
        ArticleModel(
          id: 1,
          source: ArticleSourceModel(id: "1", name: "Source 1"),
          title: "Microsoft Article 1",
          queryTitle: "Microsoft",
        ),
        ArticleModel(
          id: 2,
          source: ArticleSourceModel(id: "2", name: "Source 2"),
          title: "Microsoft Article 2",
          queryTitle: "Microsoft",
        ),
      ];

      final sortedArticles = _circularSortArticles(singleCompanyArticles);
      expect(sortedArticles.length, equals(2));
      expect(sortedArticles[0].queryTitle, equals("Microsoft"));
      expect(sortedArticles[1].queryTitle, equals("Microsoft"));
    });

    test('should handle articles with unknown company names', () {
      final mixedArticles = [
        ArticleModel(
          id: 1,
          source: ArticleSourceModel(id: "1", name: "Source 1"),
          title: "Microsoft Article",
          queryTitle: "Microsoft",
        ),
        ArticleModel(
          id: 2,
          source: ArticleSourceModel(id: "2", name: "Source 2"),
          title: "Unknown Company Article",
          queryTitle: "UnknownCompany",
        ),
        ArticleModel(
          id: 3,
          source: ArticleSourceModel(id: "3", name: "Source 3"),
          title: "Apple Article",
          queryTitle: "Apple",
        ),
      ];

      final sortedArticles = _circularSortArticles(mixedArticles);

      // Should include all articles, with unknown companies at the end
      expect(sortedArticles.length, equals(3));
      expect(sortedArticles[0].queryTitle, equals("Microsoft"));
      expect(sortedArticles[1].queryTitle, equals("Apple"));
      expect(sortedArticles[2].queryTitle, equals("UnknownCompany"));
    });

    test('should maintain article integrity during sorting', () {
      final sortedArticles = _circularSortArticles(testArticles);

      // Verify all original articles are present
      expect(sortedArticles.length, equals(testArticles.length));

      // Verify all IDs are present
      final originalIds = testArticles.map((a) => a.id).toSet();
      final sortedIds = sortedArticles.map((a) => a.id).toSet();
      expect(sortedIds, equals(originalIds));

      // Verify all titles are present
      final originalTitles = testArticles.map((a) => a.title).toSet();
      final sortedTitles = sortedArticles.map((a) => a.title).toSet();
      expect(sortedTitles, equals(originalTitles));
    });

    test('should handle large number of articles', () {
      // Create 100 articles with random company distribution
      final largeArticleList = <ArticleModel>[];
      final companies = ["Microsoft", "Apple", "Google", "Tesla"];

      for (int i = 0; i < 100; i++) {
        largeArticleList.add(ArticleModel(
          id: i,
          source: ArticleSourceModel(id: "$i", name: "Source $i"),
          title: "Article $i",
          queryTitle: companies[i % companies.length],
        ));
      }

      final sortedArticles = _circularSortArticles(largeArticleList);

      expect(sortedArticles.length, equals(100));

      // Verify round-robin pattern for first 20 articles
      for (int i = 0; i < 20; i++) {
        final expectedCompany = companies[i % companies.length];
        expect(sortedArticles[i].queryTitle, equals(expectedCompany));
      }
    });

    test('should handle all companies equally distributed', () {
      // Create articles with equal distribution
      final equalDistributionArticles = [
        ArticleModel(
            id: 1,
            source: ArticleSourceModel(id: "1", name: "Source 1"),
            title: "Microsoft 1",
            queryTitle: "Microsoft"),
        ArticleModel(
            id: 2,
            source: ArticleSourceModel(id: "2", name: "Source 2"),
            title: "Apple 1",
            queryTitle: "Apple"),
        ArticleModel(
            id: 3,
            source: ArticleSourceModel(id: "3", name: "Source 3"),
            title: "Google 1",
            queryTitle: "Google"),
        ArticleModel(
            id: 4,
            source: ArticleSourceModel(id: "4", name: "Source 4"),
            title: "Tesla 1",
            queryTitle: "Tesla"),
        ArticleModel(
            id: 5,
            source: ArticleSourceModel(id: "5", name: "Source 5"),
            title: "Microsoft 2",
            queryTitle: "Microsoft"),
        ArticleModel(
            id: 6,
            source: ArticleSourceModel(id: "6", name: "Source 6"),
            title: "Apple 2",
            queryTitle: "Apple"),
        ArticleModel(
            id: 7,
            source: ArticleSourceModel(id: "7", name: "Source 7"),
            title: "Google 2",
            queryTitle: "Google"),
        ArticleModel(
            id: 8,
            source: ArticleSourceModel(id: "8", name: "Source 8"),
            title: "Tesla 2",
            queryTitle: "Tesla"),
      ];

      final sortedArticles = _circularSortArticles(equalDistributionArticles);

      // Should maintain perfect round-robin
      expect(sortedArticles[0].queryTitle, equals("Microsoft"));
      expect(sortedArticles[1].queryTitle, equals("Apple"));
      expect(sortedArticles[2].queryTitle, equals("Google"));
      expect(sortedArticles[3].queryTitle, equals("Tesla"));
      expect(sortedArticles[4].queryTitle, equals("Microsoft"));
      expect(sortedArticles[5].queryTitle, equals("Apple"));
      expect(sortedArticles[6].queryTitle, equals("Google"));
      expect(sortedArticles[7].queryTitle, equals("Tesla"));
    });
  });
}

/// Circular sort algorithm implementation for testing
/// This simulates the actual implementation in ArticlesRepositoryImpl
List<ArticleModel> _circularSortArticles(List<ArticleModel> items) {
  final order = ['Microsoft', 'Apple', 'Google', 'Tesla'];
  final buckets = {for (var o in order) o: <ArticleModel>[]};
  final unknownArticles = <ArticleModel>[];

  // Group articles by company
  for (var item in items) {
    if (buckets.containsKey(item.queryTitle)) {
      buckets[item.queryTitle]!.add(item);
    } else {
      unknownArticles.add(item);
    }
  }

  final sorted = <ArticleModel>[];
  int i = 0;
  int maxIterations = items.length * order.length; // Prevent infinite loop
  int iterations = 0;

  // Round-robin distribution: take one article from each company in order
  while (sorted.length < items.length - unknownArticles.length &&
      iterations < maxIterations) {
    final cat = order[i % order.length];
    if (buckets[cat]!.isNotEmpty) {
      sorted.add(buckets[cat]!.removeAt(0));
    }
    i++;
    iterations++;
  }

  // Add any remaining items that weren't sorted (fallback)
  for (var bucket in buckets.values) {
    sorted.addAll(bucket);
  }

  // Add unknown company articles at the end
  sorted.addAll(unknownArticles);

  return sorted;
}
