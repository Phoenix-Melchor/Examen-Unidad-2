import 'package:examen_johan_melchor/screens/profile_screen.dart';
import 'package:examen_johan_melchor/screens/search_screen.dart';
import 'package:examen_johan_melchor/screens/seenProducts_screen.dart';
import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/screens/shoppingCart_screen.dart';
import 'package:examen_johan_melchor/infrastructure/preference_service.dart';
import 'package:examen_johan_melchor/routes.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  final PreferencesService preferencesService = PreferencesService();

  final List<Widget> _pages = [
    SearchScreen(),
    CartScreen(),
    SeenproductsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    String? token = await preferencesService.getAuthToken();
    if (token == null) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscador',
            backgroundColor: const Color.fromARGB(255, 255, 102, 0)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Productos vistos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
