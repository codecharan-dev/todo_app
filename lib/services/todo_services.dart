import 'dart:convert';

import 'package:http/http.dart' as http;

/// All todo API call will be done here
class TodoService {
  static Future<bool> deleteById({required String id}) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodos() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=20";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonDecoder = jsonDecode(response.body) as Map;
      final result = jsonDecoder["items"] as List;
      return result;
    } else {
      return null;
    }
  }
}
