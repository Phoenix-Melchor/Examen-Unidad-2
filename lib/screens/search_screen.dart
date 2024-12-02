import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/modules/search/use_case/get_search.dart';
import 'package:examen_johan_melchor/modules/search/domain/dto/search.dart';
import 'package:examen_johan_melchor/modules/search/domain/repository/search_repository.dart';
import 'package:examen_johan_melchor/screens/product_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isLoading = false;

  final GetSearchResults getSearchResults = GetSearchResults(
    SearchRepository('https://dummyjson.com'),
  );

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await getSearchResults.execute(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar productos')),
      );
    }
  }

  Future<void> _addProductToSeen(SearchResult product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? seenData = prefs.getString('visited');
    List<dynamic> seenProducts = seenData != null ? jsonDecode(seenData) : [];

    int productIndex = seenProducts.indexWhere((p) => p['id'] == product.id);
    if (productIndex != -1) {
      seenProducts[productIndex]['visits'] =
          (seenProducts[productIndex]['visits'] ?? 0) + 1;
    } else {
      seenProducts.add({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.thumbnail,
        'visits': 1,
      });
    }

    await prefs.setString('visited', jsonEncode(seenProducts));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buscador',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (query) => _searchProducts(query),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(child: Text('No se encontraron productos'))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final product = _searchResults[index];
                          return ListTile(
                            leading: Image.network(
                              product.thumbnail,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported);
                              },
                            ),
                            title: Text(product.title),
                            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                            onTap: () async {
                              await _addProductToSeen(product);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(productId: product.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}