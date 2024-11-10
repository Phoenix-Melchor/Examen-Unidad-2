import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/screens/login_screen.dart';
import 'package:examen_johan_melchor/screens/categories_screen.dart';
import 'package:examen_johan_melchor/screens/products_screen.dart';
import 'package:examen_johan_melchor/screens/shoppingCart_screen.dart';
import 'package:examen_johan_melchor/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      initialRoute: Routes.login,
      onGenerateRoute: (settings) {
        if (settings.name == Routes.login) {
          return MaterialPageRoute(builder: (context) => LoginScreen());
        } else if (settings.name == Routes.categories) {
          return MaterialPageRoute(builder: (context) => CategoriesScreen());
        } else if (settings.name!.startsWith(Routes.products)) {
          final categorySlug = settings.name!.substring(Routes.products.length);
          return MaterialPageRoute(
            builder: (context) => ProductsScreen(categorySlug: categorySlug),
          );
        } else if (settings.name == Routes.cart) {
          return MaterialPageRoute(builder: (context) => CartScreen());
        }
        return null;
      },
    );
  }
}
