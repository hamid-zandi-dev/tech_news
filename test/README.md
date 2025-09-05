# Article Feature Test Suite

This directory contains comprehensive tests for the Article feature, covering all layers of the application architecture.

## Test Structure

### Data Layer Tests
- **`circular_sort_test.dart`** - Tests for the circular sorting algorithm that distributes articles in round-robin fashion by company
- **`articles_repository_test.dart`** - Tests for the repository implementation including local/remote data handling

### Domain Layer Tests  
- **`article_model_test.dart`** - Tests for the ArticleModel data class and its properties
- **`get_articles_usecase_test.dart`** - Tests for the GetArticlesUsecase business logic

### Presentation Layer Tests
- **`article_list_bloc_test.dart`** - Tests for the ArticleListBloc state management
- **`article_item_widget_test.dart`** - Tests for the ArticleItemWidget UI component

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Files
```bash
# Run circular sort tests
flutter test test/features/article/data/repository/circular_sort_test.dart

# Run bloc tests
flutter test test/features/article/presentation/bloc/article_list_bloc_test.dart

# Run widget tests
flutter test test/features/article/presentation/widget/article_item_widget_test.dart
```

### Run Test Suite
```bash
flutter test test/article_feature_test_suite.dart
```

## Test Coverage

### Circular Sort Algorithm Tests
- ✅ Round-robin distribution verification
- ✅ Uneven distribution handling
- ✅ Empty list handling
- ✅ Single company articles
- ✅ Unknown company names
- ✅ Article integrity maintenance
- ✅ Large dataset handling

### Article Model Tests
- ✅ Property initialization
- ✅ Default value handling
- ✅ Named constructor functionality
- ✅ Mutable vs immutable properties
- ✅ Multiple instance independence
- ✅ Empty string handling
- ✅ Long content handling

### Use Case Tests
- ✅ Successful article retrieval
- ✅ Failure handling
- ✅ Parameter passing verification
- ✅ Empty results handling
- ✅ Different failure types
- ✅ Stream handling
- ✅ Exception handling

### Bloc Tests
- ✅ Initial state verification
- ✅ Page reset functionality
- ✅ Loading states (initial and pagination)
- ✅ Success response handling
- ✅ Error response handling
- ✅ Pagination logic
- ✅ End of data handling
- ✅ Edge cases and rapid events

### Repository Tests
- ✅ Local data retrieval
- ✅ Remote data fallback
- ✅ Circular sort application
- ✅ Error handling
- ✅ Empty response handling
- ✅ Data persistence

### Widget Tests
- ✅ Content display verification
- ✅ Company badge positioning
- ✅ Tap event handling
- ✅ Null listener handling
- ✅ Placeholder image handling
- ✅ Long text content
- ✅ Special characters
- ✅ Layout structure
- ✅ Empty string handling

## Dependencies

The tests use the following packages:
- `flutter_test` - Core testing framework
- `mockito` - Mocking framework for dependencies
- `bloc_test` - Testing utilities for BLoC pattern

## Mock Classes

Tests include mock implementations for:
- `ArticlesRepository`
- `GetArticlesUsecase`
- `LocalArticlesDataSource`
- `RemoteArticlesDataSource`
- `LocalArticleMapper`
- `RemoteArticleMapper`

## Test Data

Tests use consistent test data including:
- Sample `ArticleModel` instances
- Sample `ArticleEntity` instances
- Mock company names (Microsoft, Apple, Google, Tesla)
- Various failure scenarios
- Edge cases and boundary conditions

## Best Practices

1. **Isolation**: Each test is independent and doesn't affect others
2. **Mocking**: External dependencies are properly mocked
3. **Coverage**: Tests cover both happy path and error scenarios
4. **Readability**: Test names clearly describe what is being tested
5. **Maintainability**: Tests are organized by feature and layer
6. **Performance**: Tests run quickly and efficiently

## Contributing

When adding new features or modifying existing ones:

1. Add corresponding tests for new functionality
2. Update existing tests if behavior changes
3. Ensure all tests pass before submitting changes
4. Maintain test coverage above 80%
5. Follow the existing test structure and naming conventions