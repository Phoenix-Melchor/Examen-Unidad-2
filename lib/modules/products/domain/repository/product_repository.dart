import 'package:examen_johan_melchor/infrastructure/app/repository.dart';
import 'package:examen_johan_melchor/infrastructure/connection/http_client.dart';
import 'package:examen_johan_melchor/modules/products/domain/dto/product.dart';
import 'dart:convert';

class ProductRepository implements Repository<Product> {
  final HttpClient client;

  ProductRepository(this.client);

  @override
  Future<List<Product>> getByCategory(String categorySlug) async {
    final response = await client.get('/products/category/$categorySlug');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> products = data['products'];
      return products.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  @override
  Future<List<Product>> getAll() async {
    throw UnimplementedError('getAll not implemented');
  }

  @override
  Future<Product> getById(String id) async {
    throw UnimplementedError('getById not implemented');
  }

  @override
  Future<void> add(Product product) async {
    throw UnimplementedError('add not implemented');
  }

  @override
  Future<void> update(Product product) async {
    throw UnimplementedError('update not implemented');
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError('delete not implemented');
  }
}
