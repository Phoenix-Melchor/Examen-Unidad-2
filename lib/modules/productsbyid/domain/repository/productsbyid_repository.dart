import 'dart:convert';
import 'package:examen_johan_melchor/infrastructure/connection/http_client.dart';
import 'package:examen_johan_melchor/modules/productsbyid/domain/dto/productsbyid.dart';

class ProductsbyidRepository {
  final HttpClient httpClient;

  ProductsbyidRepository(this.httpClient);

  Future<ProductDetail> getProductDetail(int productId) async {
    var response = await httpClient.get('/products/$productId');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return ProductDetail.fromJson(data);
    } else {
      throw Exception('Failed to load product detail with status code: ${response.statusCode}');
    }
  }
}
