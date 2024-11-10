import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/modules/productsbyid/use_case/get_productsbyid.dart';
import 'package:examen_johan_melchor/modules/productsbyid/domain/dto/productsbyid.dart';
import 'package:examen_johan_melchor/infrastructure/connection/http_client.dart';
import 'package:examen_johan_melchor/infrastructure/preference_service.dart';
import 'package:examen_johan_melchor/modules/productsbyid/domain/repository/productsbyid_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:examen_johan_melchor/routes.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<ProductDetail> futureProductDetail;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureProductDetail = GetProductbyid(
      productDetailRepository: ProductsbyidRepository(HttpClient(
        baseUrl: 'https://dummyjson.com',
        preferencesService: PreferencesService(),
      )),
      preferencesService: PreferencesService(),
    ).execute(widget.productId);
  }

  Future<void> _addToCart(ProductDetail product) async {
    int? quantity = int.tryParse(_quantityController.text);

    if (quantity == null || quantity <= 0) {
      _showAlert('Introduce una cantidad válida mayor a cero');
      return;
    }

    if (quantity > product.stock) {
      _showAlert('La cantidad no puede ser mayor al stock disponible ${product.stock}');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    List<dynamic> cart = cartData != null ? jsonDecode(cartData) : [];

    int existingProductIndex = cart.indexWhere((item) => item['id'] == product.id);

    if (existingProductIndex != -1) {
      // Producto ya existe, actualizar cantidad y total
      int existingQuantity = cart[existingProductIndex]['quantity'];
      int newTotalQuantity = existingQuantity + quantity;

      if (newTotalQuantity > product.stock) {
        _showAlert('No puedes agregar más de la cantidad disponible en stock (${product.stock})');
        return;
      }

      cart[existingProductIndex]['quantity'] = newTotalQuantity;
      cart[existingProductIndex]['total'] = newTotalQuantity * product.price;
    } else {
      if (cart.length >= 7) {
        _showAlert('No puedes agregar más de 7 productos diferentes al carrito');
        return;
      }

      cart.add({
        'id': product.id,
        'name': product.title,
        'quantity': quantity,
        'price': product.price,
        'total': quantity * product.price,
        'date': DateTime.now().toString(),
        'image': product.image,
        'stock': product.stock,
        'description': product.description,
      });
    }

    await prefs.setString('cart', jsonEncode(cart));
    _showAlert('Producto agregado al carrito exitosamente');
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Atención'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Producto',
        style: TextStyle(
          color: Colors.white,
        )
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, Routes.cart);
            },
          ),
        ],
      ),
      body: FutureBuilder<ProductDetail>(
        future: futureProductDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No se encontró el producto'));
          } else {
            final product = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        product.title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(product.description),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Precio: \$${product.price}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text("Stock: ${product.stock}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cantidad',
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () => _addToCart(product),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: const Color.fromARGB(255, 255, 102, 0),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                          child: Text('Agregar', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
