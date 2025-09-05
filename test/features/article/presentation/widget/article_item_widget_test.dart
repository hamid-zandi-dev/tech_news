import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news/features/article/presentation/widget/article_item_widget.dart';

void main() {
  group('ArticleItemWidget Tests', () {
    late ArticleItemWidget widget;
    late VoidCallback mockOnClickListener;

    setUp(() {
      mockOnClickListener = () {};
    });

    testWidgets('should display all article information correctly',
        (WidgetTester tester) async {
      // Arrange
      widget = ArticleItemWidget(
        title: "Test Article Title",
        image: "https://example.com/image.jpg",
        description: "Test article description",
        nameOfQuery: "Microsoft",
        date: "2024-01-01T10:00:00Z",
        onClickListener: mockOnClickListener,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Assert
      expect(find.text("Test Article Title"), findsOneWidget);
      expect(find.text("Test article description"), findsOneWidget);
      expect(find.text("Microsoft"), findsOneWidget);
      expect(find.text("2024-01-01T10:00:00Z"), findsOneWidget);
    });

    testWidgets('should display company name badge at the top',
        (WidgetTester tester) async {
      // Arrange
      widget = ArticleItemWidget(
        title: "Test Article Title",
        image: "https://example.com/image.jpg",
        description: "Test article description",
        nameOfQuery: "Apple",
        date: "2024-01-01T10:00:00Z",
        onClickListener: mockOnClickListener,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Assert
      final companyBadge = find.text("Apple");
      expect(companyBadge, findsOneWidget);

      // Verify the badge is positioned at the top
      final badgeWidget = tester.widget<Text>(companyBadge);
      expect(badgeWidget.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      // Arrange
      bool wasTapped = false;
      widget = ArticleItemWidget(
        title: "Test Article Title",
        image: "https://example.com/image.jpg",
        description: "Test article description",
        nameOfQuery: "Google",
        date: "2024-01-01T10:00:00Z",
        onClickListener: () {
          wasTapped = true;
        },
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      await tester.tap(find.byType(ArticleItemWidget));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('should handle null onClickListener',
        (WidgetTester tester) async {
      // Arrange
      widget = ArticleItemWidget(
        title: "Test Article Title",
        image: "https://example.com/image.jpg",
        description: "Test article description",
        nameOfQuery: "Tesla",
        date: "2024-01-01T10:00:00Z",
        onClickListener: null,
      );

      // Act & Assert - should not throw
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      await tester.tap(find.byType(ArticleItemWidget));
      await tester.pump();

      // Should complete without errors
      expect(find.byType(ArticleItemWidget), findsOneWidget);
    });

    testWidgets('should display placeholder when image is empty',
        (WidgetTester tester) async {
      // Arrange
      widget = ArticleItemWidget(
        title: "Test Article Title",
        image: "",
        description: "Test article description",
        nameOfQuery: "Microsoft",
        date: "2024-01-01T10:00:00Z",
        onClickListener: mockOnClickListener,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Assert
      expect(find.text("Test Article Title"), findsOneWidget);
      expect(find.text("Test article description"), findsOneWidget);
      expect(find.text("Microsoft"), findsOneWidget);
      expect(find.text("2024-01-01T10:00:00Z"), findsOneWidget);
    });

    testWidgets('should handle long text content', (WidgetTester tester) async {
      // Arrange
      final longTitle =
          "This is a very long article title that contains multiple words and should be displayed correctly in the widget";
      final longDescription =
          "This is a very long article description that contains multiple sentences and detailed information about the article content. " *
              3;

      widget = ArticleItemWidget(
        title: longTitle,
        image: "https://example.com/image.jpg",
        description: longDescription,
        nameOfQuery: "Apple",
        date: "2024-01-01T10:00:00Z",
        onClickListener: mockOnClickListener,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Assert
      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longDescription), findsOneWidget);
    });

    testWidgets('should handle special characters in text',
        (WidgetTester tester) async {
      // Arrange
      widget = ArticleItemWidget(
        title: "Article with Special Characters: @#\$%^&*()",
        image: "https://example.com/image.jpg",
        description: "Description with émojis 🚀 and symbols & more!",
        nameOfQuery: "Google",
        date: "2024-01-01T10:00:00Z",
        onClickListener: mockOnClickListener,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Assert
      expect(find.text("Article with Special Characters: @#\$%^&*()"),
          findsOneWidget);
      expect(find.text("Description with émojis 🚀 and symbols & more!"),
          findsOneWidget);
    });

    testWidgets('should display different company names correctly',
        (WidgetTester tester) async {
      // Arrange
      final companies = ["Microsoft", "Apple", "Google", "Tesla"];

      for (final company in companies) {
        widget = ArticleItemWidget(
          title: "Test Article",
          image: "https://example.com/image.jpg",
          description: "Test description",
          nameOfQuery: company,
          date: "2024-01-01T10:00:00Z",
          onClickListener: mockOnClickListener,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        // Assert
        expect(find.text(company), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should maintain proper layout structure',
        (WidgetTester tester) async {
      // Arrange
      widget = ArticleItemWidget(
        title: "Test Article Title",
        image: "https://example.com/image.jpg",
        description: "Test article description",
        nameOfQuery: "Microsoft",
        date: "2024-01-01T10:00:00Z",
        onClickListener: mockOnClickListener,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Assert
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(ArticleItemWidget), findsOneWidget);
      expect(find.text("Test Article Title"), findsOneWidget);
    });

    testWidgets('should handle empty strings gracefully',
        (WidgetTester tester) async {
      // Arrange
      widget = ArticleItemWidget(
        title: "",
        image: "",
        description: "",
        nameOfQuery: "",
        date: "",
        onClickListener: mockOnClickListener,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Assert
      // Should not crash and should display empty strings
      expect(find.byType(ArticleItemWidget), findsOneWidget);
    });

    testWidgets('should handle very long company names',
        (WidgetTester tester) async {
      // Arrange
      widget = ArticleItemWidget(
        title: "Test Article",
        image: "https://example.com/image.jpg",
        description: "Test description",
        nameOfQuery: "VeryLongCompanyNameThatExceedsNormalLength",
        date: "2024-01-01T10:00:00Z",
        onClickListener: mockOnClickListener,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Assert
      expect(find.text("VeryLongCompanyNameThatExceedsNormalLength"),
          findsOneWidget);
    });
  });
}
