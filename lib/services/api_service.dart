import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://mydua.online/wp-json/customapi/v1";
  final String authToken = "MTAtMjAtMjAyMyAwOToyNDoyNkZ6VXI1MURKRGJZZ3dodVk=";

  Future<T> fetchData<T>({
    required String endpoint,
    String method = 'GET',
    Map<String, String> data = const {},
    Map<String, String>? query,
    bool showApiError = false,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
      final request = http.Request(method, uri);
      request.headers['Authorization'] = 'Bearer $authToken';
      request.bodyFields = data;
      log('Request: $request');

      final response = await http.Client().send(request);
      final body = await response.stream.bytesToString();
      log('Response: $body');

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(body);
        if (jsonResponse is List<dynamic>) {
          return jsonResponse.map((item) => fromJson(item)).toList() as T;
        } else {
          return fromJson(jsonResponse);
        }
      } else if (showApiError) {
        final bodyJson = jsonDecode(body);
        throw Exception(bodyJson['message']);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error: $e');
      throw Exception(e.toString());
    }
  }
}
