import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jmp/models/report.dart';

void main() {
  group('Report Model Tests', () {
    test('should create Report with all required fields', () {
      // Arrange & Act
      final report = Report(
        id: 'test123',
        title: 'Complete Report',
        description: 'Full report with all fields',
        createdAt: DateTime.now(),
        userId: 'testuser',
        data: {'skills': ['python', 'javascript']},
      );

      // Assert
      expect(report.id, equals('test123'));
      expect(report.title, equals('Complete Report'));
      expect(report.description, equals('Full report with all fields'));
      expect(report.userId, equals('testuser'));
      expect(report.data, equals({'skills': ['python', 'javascript']}));
      expect(report.createdAt, isA<DateTime>());
    });

    test('should convert Report to Map correctly', () {
      // Arrange
      final testDate = DateTime(2024, 1, 15, 10, 30, 45);
      final report = Report(
        id: 'report789',
        title: 'Test Report',
        description: 'Test description',
        createdAt: testDate,
        userId: 'user789',
        data: {
          'skills': ['dart', 'flutter'],
          'areas': ['mobile development'],
        },
      );

      // Act
      final map = report.toMap();

      // Assert
      expect(map['title'], equals('Test Report'));
      expect(map['description'], equals('Test description'));
      expect(map['userId'], equals('user789'));
      expect(map['createdAt'], isA<Timestamp>());
      expect(map['data'], equals({
        'skills': ['dart', 'flutter'],
        'areas': ['mobile development'],
      }));
    });

    test('should handle Timestamp conversion correctly', () {
      // Arrange
      final testDate = DateTime(2024, 1, 15, 10, 30, 45);
      final report = Report(
        id: 'report999',
        title: 'Timestamp Test',
        description: 'Testing timestamp conversion',
        createdAt: testDate,
        userId: 'user999',
        data: {},
      );

      // Act
      final map = report.toMap();

      // Assert
      expect(map['createdAt'], isA<Timestamp>());
      final timestamp = map['createdAt'] as Timestamp;
      expect(timestamp.toDate(), equals(testDate));
    });

    test('should create Report with empty data', () {
      // Arrange & Act
      final report = Report(
        id: 'empty123',
        title: 'Empty Report',
        description: 'Report with empty data',
        createdAt: DateTime.now(),
        userId: 'user123',
        data: {},
      );

      // Assert
      expect(report.id, equals('empty123'));
      expect(report.title, equals('Empty Report'));
      expect(report.data, isEmpty);
    });

    test('should create Report with complex data structure', () {
      // Arrange & Act
      final complexData = {
        'skills': ['python', 'javascript', 'react'],
        'areas': ['web development', 'data science'],
        'recommendations': ['Learn React', 'Practice algorithms'],
        'metadata': {
          'generatedAt': DateTime.now().toIso8601String(),
          'version': '1.0.0',
        },
      };

      final report = Report(
        id: 'complex123',
        title: 'Complex Report',
        description: 'Report with complex data structure',
        createdAt: DateTime.now(),
        userId: 'user456',
        data: complexData,
      );

      // Assert
      expect(report.data, equals(complexData));
      expect(report.data['skills'], equals(['python', 'javascript', 'react']));
      expect(report.data['metadata'], isA<Map>());
    });

    test('should handle special characters in title and description', () {
      // Arrange & Act
      final report = Report(
        id: 'special123',
        title: 'Career Analysis Report - 2024!',
        description: 'Comprehensive analysis with special chars: @#\$%^&*()',
        createdAt: DateTime.now(),
        userId: 'user789',
        data: {'key': 'value'},
      );

      // Assert
      expect(report.title, equals('Career Analysis Report - 2024!'));
      expect(report.description, equals('Comprehensive analysis with special chars: @#\$%^&*()'));
    });
  });
} 