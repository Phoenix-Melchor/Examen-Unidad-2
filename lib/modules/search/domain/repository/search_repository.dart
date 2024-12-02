import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen_johan_melchor/modules/search/domain/dto/search.dart';

class SearchRepository {
  final String baseUrl;

  SearchRepository(this.baseUrl);

  Future<List<SearchResult>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/products/search?q=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['products'] as List)
          .map((json) => SearchResult.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al buscar productos');
    }
  }
}
