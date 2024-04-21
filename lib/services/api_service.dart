import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "https://mydua.online/wp-json/customapi/v1";
  static const String authToken = "MTAtMjAtMjAyMyAwOToyNDoyNkZ6VXI1MURKRGJZZ3dodVk=";

  Future<T> fetchData<T>({
    required String endpoint,
    String baseUrl = apiUrl,
    String method = 'GET',
    Map<String, String> headers = const {
      'Authorization': 'Bearer $authToken',
    },
    Map<String, String> data = const {},
    Map<String, String>? query,
    bool showApiError = false,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
      final request = http.Request(method, uri);
      request.headers.addAll(headers);
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

  Future<List<T>> fetchListData<T>({
    required String endpoint,
    String baseUrl = apiUrl,
    String method = 'GET',
    Map<String, String> headers = const {
      'Authorization': 'Bearer $authToken',
    },
    Map<String, String> data = const {},
    Map<String, String>? query,
    bool showApiError = false,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
      final request = http.Request(method, uri);
      request.headers.addAll(headers);
      request.bodyFields = data;
      log('Request: $request');

      final response = await http.Client().send(request);
      final body = await response.stream.bytesToString();
      log('Response: $body');

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(body);
        if (jsonResponse is List<dynamic>) {
          return jsonResponse.map((item) => fromJson(item)).toList();
        } else {
          throw Exception('Response is not a list');
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
