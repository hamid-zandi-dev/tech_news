# Article Feature Test Suite

This directory contains comprehensive tests for the Article feature, covering all layers of the application architecture.

## Test Structure

### Working Tests (No External Dependencies)
- **`simple_article_model_test.dart`** - Tests for the ArticleModel data class and its properties
- **`simple_circular_sort_test.dart`** - Tests for the circular sorting algorithm that distributes articles in round-robin fashion by company
- **`simple_article_item_widget_test.dart`** - Tests for the ArticleItemWidget UI component

### Advanced Tests (Require External Dependencies)
- **`get_articles_usecase_test.dart`** - Tests for the GetArticlesUsecase business logic (requires mockito)
- **`article_list_bloc_test.dart`** - Tests for the ArticleListBloc state management (requires mockito + bloc_test)
- **`articles_repository_test.dart`** - Tests for the repository implementation (requires mockito)

## Running Tests

### Run Working Tests (Recommended)
```bash
# Run all working tests
flutter test test/simple_article_feature_test_suite.dart

# Run individual test files
flutter test test/features/article/domain/model/simple_article_model_test.dart
flutter test test/features/article/data/repository/simple_circular_sort_test.dart
flutter test test/features/article/presentation/widget/simple_article_item_widget_test.dart
```

### Run All Tests (Requires Dependencies)
```bash
# First install dependencies
flutter pub add --dev mockito build_runner bloc_test

# Generate mocks
flutter packages pub run build_runner build

# Then run all tests
flutter test
```

## Test Coverage

### ✅ Article Model Tests (Working)
- Property initialization and validation
- Default value handling
- Named constructor functionality
- Mutable vs immutable properties
- Multiple instance independence
- Empty string handling
- Long content handling
- Null ID handling

### ✅ Circular Sort Algorithm Tests (Working)
- Round-robin distribution verification
- Uneven distribution handling
- Empty list handling
- Single company articles
- Unknown company names
- Article integrity maintenance
- Large dataset handling (100+ articles)
- Equal distribution scenarios

### ✅ Widget Tests (Working)
- Content display verification
- Company badge positioning
- Tap event handling
- Null listener handling
- Placeholder image handling
- Long text content
- Special characters
- Layout structure
- Empty string handling
- Different company names

### 🔧 Advanced Tests (Require Setup)
- Use case business logic
- Bloc state management
- Repository data handling
- Error scenarios
- Pagination logic
- Network failure handling

## Key Test Scenarios

### Circular Sort Algorithm
The circular sort algorithm is thoroughly tested with various scenarios:

```dart
// Input: [Microsoft, Microsoft, Apple, Apple, Google, Tesla]
// Output: [Microsoft, Apple, Google, Tesla, Microsoft, Apple]

// Handles uneven distribution
// Handles empty lists
// Handles unknown companies
// Maintains article integrity
// Scales to large datasets
```

### Article Model
Tests cover all aspects of the ArticleModel:

```dart
// Property validation
// Default values
// Mutable queryTitle
// Immutable other properties
// Multiple instances
// Edge cases
```

### Widget Functionality
Comprehensive widget testing:

```dart
// Display all content
// Handle user interactions
// Manage different states
// Handle edge cases
// Maintain layout structure
```

## Test Data

Tests use consistent test data including:
- Sample `ArticleModel` instances
- Mock company names (Microsoft, Apple, Google, Tesla)
- Various failure scenarios
- Edge cases and boundary conditions
- Long text content
- Special characters

## Dependencies

### Working Tests
- `flutter_test` - Core testing framework (included by default)

### Advanced Tests (Optional)
- `mockito` - Mocking framework for dependencies
- `bloc_test` - Testing utilities for BLoC pattern
- `build_runner` - Code generation for mocks

## Best Practices

1. **Isolation**: Each test is independent and doesn't affect others
2. **Coverage**: Tests cover both happy path and error scenarios
3. **Readability**: Test names clearly describe what is being tested
4. **Maintainability**: Tests are organized by feature and layer
5. **Performance**: Tests run quickly and efficiently
6. **No External Dependencies**: Core tests work without additional packages

## Test Results

### Expected Output
```
✓ Article Model Tests
  ✓ should create ArticleModel with all properties
  ✓ should create ArticleModel with default values
  ✓ should create ArticleModel.withId constructor
  ✓ should allow modification of queryTitle
  ✓ should handle null id
  ✓ should create multiple instances independently
  ✓ should handle empty strings correctly
  ✓ should handle long text content

✓ Circular Sort Algorithm Tests
  ✓ should distribute articles in round-robin fashion
  ✓ should handle uneven distribution of articles
  ✓ should handle empty list
  ✓ should handle single company articles
  ✓ should handle articles with unknown company names
  ✓ should maintain article integrity during sorting
  ✓ should handle large number of articles
  ✓ should handle all companies equally distributed

✓ ArticleItemWidget Tests
  ✓ should display all article information correctly
  ✓ should display company name badge at the top
  ✓ should handle tap events
  ✓ should handle null onClickListener
  ✓ should display placeholder when image is empty
  ✓ should handle long text content
  ✓ should handle special characters in text
  ✓ should display different company names correctly
  ✓ should maintain proper layout structure
  ✓ should handle empty strings gracefully
  ✓ should handle very long company names

All tests passed! 🎉
```

## Contributing

When adding new features or modifying existing ones:

1. Add corresponding tests for new functionality
2. Update existing tests if behavior changes
3. Ensure all tests pass before submitting changes
4. Follow the existing test structure and naming conventions
5. Prefer simple tests that don't require external dependencies when possible

## Troubleshooting

### Common Issues

1. **Missing Dependencies**: Install required packages with `flutter pub add --dev mockito bloc_test`
2. **Mock Generation**: Run `flutter packages pub run build_runner build` to generate mocks
3. **Import Errors**: Check that all imports are correct and files exist
4. **Test Failures**: Review test logic and ensure test data is correct

### Getting Help

- Check the test output for specific error messages
- Review the test code for logical errors
- Ensure all dependencies are properly installed
- Verify that the code being tested is working correctly