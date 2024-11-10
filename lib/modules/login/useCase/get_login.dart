import 'package:examen_johan_melchor/modules/login/domain/dto/login.dart';
import 'package:examen_johan_melchor/modules/login/domain/repository/login_repository.dart';
import 'package:examen_johan_melchor/infrastructure/preference_service.dart';

class LoginUseCase {
  final LoginRepository loginRepository;
  final PreferencesService preferencesService;

  LoginUseCase(this.loginRepository, this.preferencesService);

  Future<void> execute(String username, String password) async {
    var login = Login(username: username, password: password);
    String token = await loginRepository.login(login);
    await preferencesService.setAuthToken(token);
  }
}

