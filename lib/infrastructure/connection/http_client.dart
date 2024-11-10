import 'package:http/http.dart' as http;
import 'package:examen_johan_melchor/infrastructure/preference_service.dart';

class HttpClient {
  final String baseUrl;
  final PreferencesService preferencesService;

  HttpClient({required this.baseUrl, required this.preferencesService});

  Future<Map<String, String>> _getHeaders({bool includeToken = true}) async {
    if (includeToken) {
      String? token = await preferencesService.getAuthToken();
      if (token != null) {
        return {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };
      } else {
        throw Exception('No se encontro el token');
      }
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }

  Future<http.Response> get(String endpoint, {bool includeToken = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeToken: includeToken);
    return await http.get(url, headers: headers);
  }

  Future<http.Response> post(String endpoint, {Map<String, String>? headers, Object? body, bool includeToken = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = await _getHeaders(includeToken: includeToken);
    final mergedHeaders = {...?headers, ...defaultHeaders};
    return await http.post(url, headers: mergedHeaders, body: body);
  }

  Future<http.Response> put(String endpoint, {Map<String, String>? headers, Object? body, bool includeToken = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = await _getHeaders(includeToken: includeToken);
    final mergedHeaders = {...?headers, ...defaultHeaders};
    return await http.put(url, headers: mergedHeaders, body: body);
  }

  Future<http.Response> delete(String endpoint, {Map<String, String>? headers, bool includeToken = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = await _getHeaders(includeToken: includeToken);
    final mergedHeaders = {...?headers, ...defaultHeaders};
    return await http.delete(url, headers: mergedHeaders);
  }
}
