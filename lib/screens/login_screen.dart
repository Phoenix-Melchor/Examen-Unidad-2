import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/routes.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login',
        style: TextStyle(
          color: Colors.white,
        )
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: 
                ElevatedButton(
                  onPressed: () {
                  Navigator.pushNamed(context, Routes.categories);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color.fromARGB(255, 255, 102, 0),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text("Ingresar", 
                  style: TextStyle(
                    color: Colors.white
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
