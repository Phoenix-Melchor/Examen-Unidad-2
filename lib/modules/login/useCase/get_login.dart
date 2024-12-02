import 'package:examen_johan_melchor/modules/login/domain/dto/login.dart';
import 'package:examen_johan_melchor/modules/login/domain/repository/login_repository.dart';
import 'package:examen_johan_melchor/infrastructure/preference_service.dart';

class LoginUseCase {
  final LoginRepository loginRepository;
  final PreferencesService preferencesService;

  LoginUseCase(this.loginRepository, this.preferencesService);

  Future<void> execute(String username, String password) async {
    var login = Login(username: username, password: password);
    var responseData = await loginRepository.login(login);

    String token = responseData['accessToken'];
    await preferencesService.setAuthToken(token);

    await preferencesService.setUserData({
      'id': responseData['id'],
      'username': responseData['username'],
      'email': responseData['email'],
      'firstName': responseData['firstName'],
      'lastName': responseData['lastName'],
      'image': responseData['image'],
    });
  }
}
