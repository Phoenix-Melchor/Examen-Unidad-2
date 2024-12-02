import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen_johan_melchor/infrastructure/connection/http_client.dart';
import 'package:examen_johan_melchor/modules/login/domain/dto/login.dart';

class LoginRepository {
  final HttpClient httpClient;

  LoginRepository(this.httpClient);

  Future<Map<String, dynamic>> login(Login loginDTO) async {
    var response = await httpClient.post(
      '/auth/login',
      body: jsonEncode(loginDTO.toJson()),
      headers: {'Content-Type': 'application/json'},
      includeToken: false,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (!data.containsKey('accessToken')) {
        throw Exception('No se encontró el Token');
      }
      return data; // Devolvemos todos los datos de la respuesta.
    } else {
      throw Exception('Failed to login with status code: ${response.statusCode}');
    }
  }
}
