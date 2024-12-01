import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario',
        style: TextStyle(
          color: Colors.white,
        )
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Pantalla del Perfil de Usuario'),
      ),
    );
  }
}
