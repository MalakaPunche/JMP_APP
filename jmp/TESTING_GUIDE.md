# JMP Flutter App Testing Guide

This guide provides comprehensive instructions for writing and running unit tests, widget tests, and integration tests for the JobMarketPulse (JMP) Flutter application.

## Table of Contents

1. [Testing Overview](#testing-overview)
2. [Test Types](#test-types)
3. [Setting Up Testing Environment](#setting-up-testing-environment)
4. [Writing Unit Tests](#writing-unit-tests)
5. [Writing Widget Tests](#writing-widget-tests)
6. [Writing Integration Tests](#writing-integration-tests)
7. [Running Tests](#running-tests)
8. [Test Best Practices](#test-best-practices)
9. [Mocking and Test Utilities](#mocking-and-test-utilities)
10. [Continuous Integration](#continuous-integration)

## Testing Overview

The JMP app uses a comprehensive testing strategy with three main types of tests:

- **Unit Tests**: Test individual functions, methods, and classes in isolation
- **Widget Tests**: Test UI components and user interactions
- **Integration Tests**: Test complete app flows and user journeys

## Test Types

### 1. Unit Tests
- **Location**: `test/unit/`
- **Purpose**: Test business logic, data models, and utility functions
- **Examples**: API service tests, model serialization, validation logic

### 2. Widget Tests
- **Location**: `test/widget/`
- **Purpose**: Test UI components, form validation, and user interactions
- **Examples**: Form validation, button interactions, screen navigation

### 3. Integration Tests
- **Location**: `test/integration/`
- **Purpose**: Test complete user flows and app functionality
- **Examples**: Authentication flow, report generation, navigation

## Setting Up Testing Environment

### Prerequisites
```bash
# Ensure you have the latest Flutter SDK
flutter doctor

# Install dependencies
flutter pub get
```

### Dependencies
The following testing dependencies are included in `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.8
  integration_test:
    sdk: flutter
```

### Generate Mock Classes
```bash
# Generate mock classes for HTTP client and other dependencies
flutter packages pub run build_runner build
```

## Writing Unit Tests

### Example: API Service Test

```dart
// test/unit/api_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:jmp/common/api_service.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService();
    });

    test('should return report response when API call is successful', () async {
      // Arrange
      const skills = 'python, javascript, react';
      const areas = 'web development, data science';
      
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"response": "Success"}', 200));

      // Act
      final result = await apiService.generateReport(
        skills: skills,
        areas: areas,
      );

      // Assert
      expect(result, equals('Success'));
    });
  });
}
```

### Example: Model Test

```dart
// test/unit/report_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:jmp/models/report.dart';

void main() {
  group('Report Model Tests', () {
    test('should create Report from Firestore document', () {
      // Arrange
      final mockData = {
        'title': 'Career Analysis Report',
        'description': 'Comprehensive analysis',
        'createdAt': Timestamp.fromDate(DateTime(2024, 1, 15)),
        'userId': 'user123',
        'data': {'skills': ['python', 'javascript']},
      };

      // Act
      final report = Report.fromFirestore(mockDoc);

      // Assert
      expect(report.title, equals('Career Analysis Report'));
      expect(report.userId, equals('user123'));
    });
  });
}
```

## Writing Widget Tests

### Example: Form Validation Test

```dart
// test/widget/report_generation_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:jmp/report_generate/report_generate.dart';

void main() {
  group('Report Generation Widget Tests', () {
    testWidgets('should show validation error for empty skills', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const ReportGenerateWidget());

      // Act
      await tester.tap(find.text('Generate Report'));
      await tester.pump();

      // Assert
      expect(find.text('Please enter your skills'), findsOneWidget);
    });

    testWidgets('should accept valid input and show loading state', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const ReportGenerateWidget());

      // Act
      await tester.enterText(find.byType(TextField).first, 'python, react, sql');
      await tester.enterText(find.byType(TextField).last, 'web development');
      await tester.tap(find.text('Generate Report'));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### Widget Test Utilities

```dart
// Helper function for creating test widgets
Widget createTestWidget() {
  return MaterialApp(
    home: ChangeNotifierProvider<ApplicationState>.value(
      value: mockAppState,
      child: const ReportGenerateWidget(),
    ),
  );
}

// Helper function for waiting for animations
Future<void> waitForAnimation(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}
```

## Writing Integration Tests

### Example: Complete App Flow Test

```dart
// test/integration/app_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:jmp/main.dart';

void main() {
  group('JMP App Integration Tests', () {
    testWidgets('should navigate through complete app flow', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Assert - Should start with splash screen
      expect(find.byType(SplashWidget), findsOneWidget);

      // Wait for splash to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Navigate through app
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Assert - Should show join page
      expect(find.text('Join JobMarketPulse'), findsOneWidget);
    });
  });
}
```

## Running Tests

### Run All Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run tests with verbose output
flutter test --verbose
```

### Run Specific Test Files
```bash
# Run unit tests only
flutter test test/unit/

# Run widget tests only
flutter test test/widget/

# Run integration tests only
flutter test test/integration/

# Run specific test file
flutter test test/unit/api_service_test.dart
```

### Run Tests on Specific Platform
```bash
# Run tests on Android
flutter test -d android

# Run tests on iOS
flutter test -d ios

# Run tests on web
flutter test -d chrome
```

### Generate Test Coverage Report
```bash
# Install lcov (if not already installed)
# On macOS: brew install lcov
# On Ubuntu: sudo apt-get install lcov

# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Best Practices

### 1. Test Structure (AAA Pattern)
```dart
test('should do something when condition is met', () async {
  // Arrange - Set up test data and conditions
  final apiService = ApiService();
  const expectedResult = 'Success';

  // Act - Execute the code being tested
  final result = await apiService.generateReport(
    skills: 'python',
    areas: 'data science',
  );

  // Assert - Verify the expected outcome
  expect(result, equals(expectedResult));
});
```

### 2. Group Related Tests
```dart
group('ApiService Tests', () {
  group('generateReport', () {
    test('should return success response', () async {
      // Test implementation
    });

    test('should handle network errors', () async {
      // Test implementation
    });
  });

  group('validateInput', () {
    test('should validate email format', () async {
      // Test implementation
    });
  });
});
```

### 3. Use Descriptive Test Names
```dart
// Good
test('should return error when API returns 500 status code', () async {});

// Bad
test('test error handling', () async {});
```

### 4. Mock External Dependencies
```dart
// Mock HTTP client
@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  late MockClient mockClient;
  
  setUp(() {
    mockClient = MockClient();
  });
}
```

### 5. Test Edge Cases
```dart
test('should handle empty input gracefully', () async {});
test('should handle null values', () async {});
test('should handle network timeout', () async {});
test('should handle malformed JSON response', () async {});
```

## Mocking and Test Utilities

### Mocking HTTP Requests
```dart
// Mock successful response
when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
    .thenAnswer((_) async => http.Response('{"response": "Success"}', 200));

// Mock error response
when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
    .thenAnswer((_) async => http.Response('{"error": "Server error"}', 500));

// Mock network exception
when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
    .thenThrow(Exception('Network error'));
```

### Mocking Firebase
```dart
// Mock Firestore document
final mockDoc = MockDocumentSnapshot();
when(mockDoc.id).thenReturn('document123');
when(mockDoc.data()).thenReturn({'title': 'Test Report'});

// Mock Firebase Auth
final mockUser = MockUser();
when(mockUser.uid).thenReturn('user123');
when(mockUser.email).thenReturn('test@example.com');
```

### Test Utilities
```dart
// Helper function for creating test data
Report createTestReport({
  String id = 'test123',
  String title = 'Test Report',
  String userId = 'user123',
}) {
  return Report(
    id: id,
    title: title,
    description: 'Test description',
    createdAt: DateTime.now(),
    userId: userId,
    data: {'skills': ['python', 'javascript']},
  );
}

// Helper function for waiting
Future<void> waitForCondition(Future<bool> Function() condition) async {
  while (!await condition()) {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
```

## Continuous Integration

### GitHub Actions Example
```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.2.3'
    
    - run: flutter pub get
    
    - run: flutter test --coverage
    
    - run: genhtml coverage/lcov.info -o coverage/html
    
    - uses: actions/upload-artifact@v3
      with:
        name: coverage-report
        path: coverage/html
```

### Test Commands for CI
```bash
# Install dependencies
flutter pub get

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Run integration tests (if needed)
flutter drive --target=test_driver/app.dart
```

## Common Testing Patterns

### 1. Testing Async Operations
```dart
test('should handle async operation', () async {
  // Arrange
  final future = Future.delayed(Duration(seconds: 1), () => 'result');
  
  // Act
  final result = await future;
  
  // Assert
  expect(result, equals('result'));
});
```

### 2. Testing Widget Interactions
```dart
testWidgets('should handle button tap', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(MyWidget());
  
  // Act
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  
  // Assert
  expect(find.text('Button pressed'), findsOneWidget);
});
```

### 3. Testing Form Validation
```dart
testWidgets('should validate form fields', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(MyForm());
  
  // Act - Submit empty form
  await tester.tap(find.text('Submit'));
  await tester.pump();
  
  // Assert
  expect(find.text('This field is required'), findsOneWidget);
});
```

### 4. Testing Navigation
```dart
testWidgets('should navigate to next screen', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(MyApp());
  
  // Act
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
  
  // Assert
  expect(find.text('Next Screen'), findsOneWidget);
});
```

## Troubleshooting

### Common Issues

1. **Test fails with "No tests found"**
   - Ensure test files end with `_test.dart`
   - Check that test functions are properly named with `test()` or `testWidgets()`

2. **Mock classes not generated**
   - Run `flutter packages pub run build_runner build`
   - Ensure `@GenerateMocks` annotation is used correctly

3. **Widget tests fail with "No Material widget found"**
   - Wrap test widget with `MaterialApp`
   - Use `tester.pumpWidget(MaterialApp(home: YourWidget()))`

4. **Integration tests fail**
   - Ensure integration test files are in `test/integration/` directory
   - Use `flutter drive` for integration tests

### Debugging Tests
```bash
# Run tests with verbose output
flutter test --verbose

# Run single test with debug output
flutter test test/unit/api_service_test.dart --verbose

# Run tests with coverage and show uncovered lines
flutter test --coverage --coverage-path=coverage/lcov.info
```

## Conclusion

This testing guide provides a comprehensive approach to testing your JMP Flutter application. By following these patterns and best practices, you can ensure your app is reliable, maintainable, and bug-free.

Remember to:
- Write tests for all critical functionality
- Use descriptive test names
- Mock external dependencies
- Test edge cases and error conditions
- Maintain good test coverage
- Run tests regularly in your development workflow

For more information, refer to the [Flutter Testing Documentation](https://docs.flutter.dev/testing). 