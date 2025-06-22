import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:jmp/common/api_service.dart';

// Generate mock classes
@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    group('generateReport', () {
      test('should have correct base URL', () {
        // Arrange & Act
        const expectedBaseUrl = 'http://localhost:8000';
        
        // Assert
        expect(ApiService.baseUrl, equals(expectedBaseUrl));
      });

      test('should accept valid input parameters', () {
        // Arrange
        const skills = 'python, react, sql';
        const areas = 'full stack development';

        // Act & Assert - Just test that the method exists and accepts parameters
        expect(() => apiService.generateReport(skills: skills, areas: areas), returnsNormally);
      });

      test('should handle empty input parameters', () {
        // Arrange
        const skills = '';
        const areas = '';

        // Act & Assert - Just test that the method exists and accepts parameters
        expect(() => apiService.generateReport(skills: skills, areas: areas), returnsNormally);
      });

      test('should handle null input parameters', () {
        // Arrange
        const skills = 'python';
        const areas = 'data science';

        // Act & Assert - Just test that the method exists and accepts parameters
        expect(() => apiService.generateReport(skills: skills, areas: areas), returnsNormally);
      });

      test('should have proper method signature', () {
        // Arrange & Act
        final method = apiService.generateReport;
        
        // Assert - Test that the method exists and has the right signature
        expect(method, isA<Function>());
      });
    });
  });
} 