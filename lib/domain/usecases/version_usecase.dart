import 'package:zoftcare_app/domain/repository/user_repository.dart';

class GetVersionUseCase {
  final UserRepository userRepository;

  GetVersionUseCase(this.userRepository);

  Future<String> getVersion() async {
    return await userRepository.getVersion();
  }
}