import 'package:zoftcare_app/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.firstName,
    required super.lastName,
    required super.token,
    required super.validity,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['user']['firstName'],
      lastName: json['user']['lastName'],
      token: json['accessToken'],
      validity: json['validity'],
    );
  }
}
