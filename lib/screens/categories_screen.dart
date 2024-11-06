import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/modules/categories/use_case/get_categories.dart';
import 'package:examen_johan_melchor/modules/categories/domain/category.dart';
import 'package:examen_johan_melchor/infrastructure/connection/http_client.dart';
import 'package:examen_johan_melchor/modules/categories/repository/category_repository.dart';
import 'package:examen_johan_melchor/routes.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final GetCategoriesUseCase getCategoriesUseCase = GetCategoriesUseCase(
    CategoryRepository(HttpClient(baseUrl: 'https://dummyjson.com')),
  );

  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = getCategoriesUseCase.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorías",
        style: TextStyle(
          color: Colors.white,
        )),
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron categorías.'));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final icon = index % 2 == 0 ? Icons.shopping_bag : Icons.fastfood;
                final color = index % 2 == 0 ? Colors.orange : Colors.green;

                return ListTile(
                  leading: Icon(icon, color: color),
                  
                  title: Text(category.name),
                  trailing: Icon(Icons.arrow_forward, color: color),
                  onTap: () {
                    // Navegar a los productos de la categoría
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}