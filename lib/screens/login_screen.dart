import 'package:flutter/material.dart';
import 'package:examen_johan_melchor/routes.dart';
import 'package:examen_johan_melchor/modules/login/usecase/get_login.dart';
import 'package:examen_johan_melchor/modules/login/domain/repository/login_repository.dart';
import 'package:examen_johan_melchor/infrastructure/connection/http_client.dart';
import 'package:examen_johan_melchor/infrastructure/preference_service.dart';



class LoginScreen extends StatelessWidget {
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

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
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController, 
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
                  onPressed: () async {
                    try {
                      LoginUseCase loginUseCase = LoginUseCase(
                        LoginRepository(HttpClient(
                          baseUrl: 'https://dummyjson.com',
                          preferencesService: PreferencesService(),
                        )),
                        PreferencesService(),
                      );
                      await loginUseCase.execute(
                        usernameController.text, 
                        passwordController.text
                      );
                      Navigator.pushNamed(context, Routes.categories);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Error de Inicio de Sesión'),
                          content: Text(e.toString()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    }
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
