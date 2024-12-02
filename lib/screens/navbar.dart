import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/screens/categories_screen.dart';
import 'package:examen_johan_melchor/screens/profile_screen.dart';
import 'package:examen_johan_melchor/screens/search_screen.dart';
import 'package:examen_johan_melchor/screens/seenProducts_screen.dart';
import 'package:examen_johan_melchor/screens/shoppingCart_screen.dart';
import 'package:examen_johan_melchor/infrastructure/preference_service.dart';
import 'package:examen_johan_melchor/routes.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Navigator(
            key: UniqueKey(),
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => CategoriesScreen());
            },
          ),
          Navigator(
            key: UniqueKey(),
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => SearchScreen());
            },
          ),
          Navigator(
            key: UniqueKey(),
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => CartScreen());
            },
          ),
          Navigator(
            key: UniqueKey(),
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => SeenProductsScreen());
            },
          ),
          Navigator(
            key: UniqueKey(),
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => ProfileScreen());
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Categorías'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscador'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Productos Vistos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

