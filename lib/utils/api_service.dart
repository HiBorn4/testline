import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://api.jsonserve.com/Uw5CrX'; // Replace with your actual API URL

  Future<Map<String, dynamic>> fetchQuizData() async {
    final response = await http.get(Uri.parse('$_baseUrl'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load quiz data');
    }
  }
}
