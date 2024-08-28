import 'package:zoftcare_app/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<String> getVersion();
}
