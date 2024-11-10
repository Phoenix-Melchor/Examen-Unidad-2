import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:examen_johan_melchor/modules/products/domain/dto/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _quantityController = TextEditingController();

  Future<void> _addToCart() async {
    int? quantity = int.tryParse(_quantityController.text);

    if (quantity == null || quantity <= 0) {
      _showAlert('Por favor, introduce una cantidad válida mayor a cero.');
      return;
    }

    if (quantity > widget.product.stock) {
      _showAlert('La cantidad no puede ser mayor al stock disponible ${widget.product.stock}');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    List<dynamic> cart = cartData != null ? jsonDecode(cartData) : [];

    int existingProductIndex = cart.indexWhere((item) => item['name'] == widget.product.title);

    if (existingProductIndex != -1) {
      // Producto ya existe, verificar la cantidad acumulada
      int existingQuantity = cart[existingProductIndex]['quantity'];
      int newTotalQuantity = existingQuantity + quantity;

      if (newTotalQuantity > widget.product.stock) {
        _showAlert('No puedes agregar más de la cantidad disponible en stock (${widget.product.stock}).');
        return;
      }

      cart[existingProductIndex]['quantity'] = newTotalQuantity;
      cart[existingProductIndex]['total'] = newTotalQuantity * widget.product.price;
    } else {
      if (cart.length >= 7) {
        _showAlert('No puedes agregar más de 7 productos diferentes al carrito.');
        return;
      }

      cart.add({
        'name': widget.product.title,
        'quantity': quantity,
        'price': widget.product.price,
        'total': quantity * widget.product.price,
        'date': DateTime.now().toString(),
      });
    }

    await prefs.setString('cart', jsonEncode(cart));
    _showAlert('Producto agregado al carrito exitosamente.');
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
        title: Text(widget.product.title,
        style: TextStyle(
          color: Colors.white,
        )),
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.product.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.product.description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Precio: \$${widget.product.price}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Stock: ${widget.product.stock}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
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
                    onPressed: _addToCart,
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
      ),
    );
  }
}
