import 'package:examen_johan_melchor/infrastructure/app/repository.dart';
import 'package:examen_johan_melchor/infrastructure/connection/http_client.dart';
import 'package:examen_johan_melchor/modules/categories/domain/category.dart';
import 'dart:convert';

class CategoryRepository implements Repository<Category> {
  final HttpClient client;

  CategoryRepository(this.client);

  @override
  Future<List<Category>> getAll() async {
    final response = await client.get('/products/categories');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las categorías');
    }
  }

  @override
  Future<Category> getById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> add(Category category) async {
    throw UnimplementedError();
  }

  @override
  Future<void> update(Category category) async {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError();
  }
}
