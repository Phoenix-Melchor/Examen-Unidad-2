import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/modules/products/domain/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title,
        style: TextStyle(
          color: Colors.white,
        )
        ),
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
                product.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  product.description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Precio: \$${product.price}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Stock: ${product.stock}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                    },
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
