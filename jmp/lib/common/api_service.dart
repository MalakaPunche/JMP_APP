import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; // Change this to your server's URL

  Future<String> generateReport({
    required String skills,
    required String areas,
  }) async {
    try {
      print('Sending to API - skills: $skills');
      print('Sending to API - areas: $areas');
      
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'skills': skills,
          'areas': areas,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        print('API Error Response: ${response.body}');
        throw Exception('Failed to generate report: ${response.statusCode}');
      }
    } catch (e) {
      print('API Connection Error: $e');
      throw Exception('Error connecting to server: $e');
    }
  }
} 