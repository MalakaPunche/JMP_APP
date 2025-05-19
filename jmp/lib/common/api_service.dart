import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; // Change this to your server's URL

  Future<String> generateReport({
    required String degree,
    required String major,
    required String university,
    required String graduationYear,
    required String workExperience,
    required String skills,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': 'Generate a career report',
          'context': jsonEncode({
            'degree': degree,
            'major': major,
            'university': university,
            'graduationYear': graduationYear,
            'workExperience': workExperience,
            'skills': skills,
          }),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to generate report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
} 