import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/screens/login_screen.dart';
import 'package:examen_johan_melchor/screens/categories_screen.dart';
import 'package:examen_johan_melchor/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(color: Colors.blue),
      ),
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => LoginScreen(),
        Routes.categories: (context) => CategoriesScreen(),
        // Añadir más rutas según se necesiten
      },
    );
  }
}
