import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:examen_johan_melchor/screens/product_detail_screen.dart';

class SeenProductsScreen extends StatefulWidget {
  @override
  _SeenProductsScreenState createState() => _SeenProductsScreenState();
}

class _SeenProductsScreenState extends State<SeenProductsScreen> {
  List<dynamic> seenProducts = [];

  @override
  void initState() {
    super.initState();
    _loadSeenProducts();
  }

  Future<void> _loadSeenProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? seenData = prefs.getString('visited');
    if (seenData != null) {
      setState(() {
        seenProducts = jsonDecode(seenData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productos Vistos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        centerTitle: true,
      ),
      body: seenProducts.isEmpty
          ? Center(child: Text('No hay productos vistos.'))
          : ListView.builder(
              itemCount: seenProducts.length,
              itemBuilder: (context, index) {
                final product = seenProducts[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      product['image'] ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product['title']),
                    subtitle: Text(
                      'Precio: \$${product['price']} - Visitas: ${product['visits']}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.info, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(productId: product['id']),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
