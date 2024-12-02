import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:examen_johan_melchor/modules/products/use_case/get_products.dart';
import 'package:examen_johan_melchor/modules/products/domain/dto/product.dart';
import 'package:examen_johan_melchor/infrastructure/connection/http_client.dart';
import 'package:examen_johan_melchor/modules/products/domain/repository/product_repository.dart';
import 'package:examen_johan_melchor/screens/product_detail_screen.dart';
import 'package:examen_johan_melchor/infrastructure/preference_service.dart';

class ProductsScreen extends StatefulWidget {
  final String categorySlug;

  ProductsScreen({required this.categorySlug});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = GetProducts(
      ProductRepository(HttpClient(baseUrl: 'https://dummyjson.com', preferencesService: PreferencesService())),
    ).execute(widget.categorySlug);
  }

  Future<void> _recordProductVisit(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? visitedData = prefs.getString('visited');
    List<dynamic> visited = visitedData != null ? jsonDecode(visitedData) : [];

    int existingIndex = visited.indexWhere((item) => item['id'] == product.id);
    if (existingIndex != -1) {
      visited[existingIndex]['visits'] += 1;
    } else {
      visited.add({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.image,
        'visits': 1,
      });
    }

    await prefs.setString('visited', jsonEncode(visited));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(product.image, fit: BoxFit.cover),
                      ),
                      Text(product.title),
                      TextButton(
                        onPressed: () async {
                          await _recordProductVisit(product);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                        child: Text('Detalles'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
