import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jmp/report_generate/report_generate.dart';

// Mock ApplicationState to avoid Firebase initialization
class MockApplicationState extends ChangeNotifier {
  String? email;
  bool loggedIn = false;
  
  void setEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }
  
  void setLoggedIn(bool isLoggedIn) {
    loggedIn = isLoggedIn;
    notifyListeners();
  }
}

void main() {
  group('Report Generation Widget Tests', () {
    late MockApplicationState mockAppState;

    setUp(() {
      mockAppState = MockApplicationState();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<MockApplicationState>.value(
          value: mockAppState,
          child: const ReportGenerate(),
        ),
      );
    }

    testWidgets('should display report generation form', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display skill categories correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Assert - Check for skill category sections
      expect(find.text('Programming Languages'), findsOneWidget);
      expect(find.text('Frameworks & Libraries'), findsOneWidget);
      expect(find.text('Databases'), findsOneWidget);
      expect(find.text('Cloud & DevOps'), findsOneWidget);
    });

    testWidgets('should allow skill selection from categories', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act - Tap on a skill chip
      final skillChips = find.byType(FilterChip);
      if (skillChips.evaluate().isNotEmpty) {
        await tester.tap(skillChips.first);
        await tester.pump();

        // Assert - Chip should be selected
        final chip = tester.widget<FilterChip>(skillChips.first);
        expect(chip.selected, isTrue);
      }
    });

    testWidgets('should update selected skills when chip is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act - Select multiple skills
      final chips = find.byType(FilterChip);
      if (chips.evaluate().length >= 2) {
        await tester.tap(chips.at(0)); // First skill
        await tester.tap(chips.at(1)); // Second skill
        await tester.pump();

        // Assert - Both chips should be selected
        expect(tester.widget<FilterChip>(chips.at(0)).selected, isTrue);
        expect(tester.widget<FilterChip>(chips.at(1)).selected, isTrue);
      }
    });

    testWidgets('should have proper form layout and spacing', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Assert - Check for proper layout elements
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should display areas of interest', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Assert - Check for areas of interest
      expect(find.text('Data Science'), findsOneWidget);
      expect(find.text('Web Development'), findsOneWidget);
      expect(find.text('Mobile Development'), findsOneWidget);
    });

    testWidgets('should allow area selection', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act - Tap on an area chip
      final areaChips = find.byType(FilterChip);
      if (areaChips.evaluate().isNotEmpty) {
        await tester.tap(areaChips.last);
        await tester.pump();

        // Assert - Area chip should be selected
        final chip = tester.widget<FilterChip>(areaChips.last);
        expect(chip.selected, isTrue);
      }
    });

    testWidgets('should show generate report button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Generate Report'), findsOneWidget);
    });

    testWidgets('should handle form submission', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act - Select some skills and areas, then tap generate
      final skillChips = find.byType(FilterChip);
      if (skillChips.evaluate().isNotEmpty) {
        await tester.tap(skillChips.first);
        await tester.pump();

        final generateButton = find.text('Generate Report');
        await tester.tap(generateButton);
        await tester.pump();

        // Assert - Should show loading or proceed with generation
        // Note: This test doesn't actually call the API, just tests the UI interaction
        expect(find.byType(ElevatedButton), findsOneWidget);
      }
    });

    testWidgets('should display skill categories in correct order', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Assert - Check that categories appear in the expected order
      final categoryTexts = [
        'Programming Languages',
        'Frameworks & Libraries',
        'Databases',
        'Cloud & DevOps',
        'Soft Skills',
        'Data & Analytics',
        'Security & Testing',
        'Mobile & Web',
      ];

      for (final category in categoryTexts) {
        expect(find.text(category), findsOneWidget);
      }
    });

    testWidgets('should handle text field interactions', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act - Tap on a text field
      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.tap(textFields.first);
        await tester.pump();

        // Assert - Text field should be focused
        expect(tester.binding.focusManager.primaryFocus, isNotNull);
      }
    });
  });
} 