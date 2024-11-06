import 'package:http/http.dart' as http;

class HttpClient {
  final String baseUrl;

  HttpClient({required this.baseUrl});

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url);
  }
}
