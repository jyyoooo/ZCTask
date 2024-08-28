import 'package:zoftcare_app/data/data_source/user_remote_source.dart';
import 'package:zoftcare_app/domain/entities/user.dart';
import 'package:zoftcare_app/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<String> getVersion() async {
    return await remoteDataSource.getVersion();
  }
}
