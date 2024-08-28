import 'package:zoftcare_app/domain/entities/user.dart';
import 'package:zoftcare_app/domain/repository/user_repository.dart';

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
