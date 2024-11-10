import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:examen_johan_melchor/screens/product_detail_screen.dart';
import 'package:examen_johan_melchor/modules/products/domain/dto/product.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  double totalSum = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      setState(() {
        cartItems = List<Map<String, dynamic>>.from(jsonDecode(cartData));
        totalSum = cartItems.fold(0, (sum, item) => sum + item['total']);
      });
    }
  }

  Future<void> _removeItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cartItems.removeAt(index);
      totalSum = cartItems.fold(0, (sum, item) => sum + item['total']);
    });
    await prefs.setString('cart', jsonEncode(cartItems));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carrito de Compras - Total: \$${totalSum.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('El carrito está vacío.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: item['image'] != null
                        ? Image.network(
                            item['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey,
                            child: Icon(Icons.image_not_supported),
                          ),
                    title: Text(item['name'] ?? 'Producto desconocido'),
                    subtitle: Text(
                      'Total: \$${item['total']?.toStringAsFixed(2) ?? '0.00'} '
                      '(\$${item['price']?.toString() ?? '0.00'} x ${item['quantity']?.toString() ?? '0'})',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            _removeItem(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.info, color: Colors.blue),
                          onPressed: () {
                            // Navegar al detalle del producto pasando solo el ID
                            if (item['id'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(productId: item['id']),
                                ),
                              );
                            } else {
                              // Mostrar un mensaje de error si no hay ID disponible
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('No se puede mostrar el detalle del producto porque falta el ID.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
