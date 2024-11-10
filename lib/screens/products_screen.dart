import 'package:flutter/material.dart';
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
      ProductRepository(HttpClient(baseUrl: 'https://dummyjson.com', preferencesService: PreferencesService(),)),
    ).execute(widget.categorySlug);  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos',
        style: TextStyle(
          color: Colors.white,
        )
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: product),
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
