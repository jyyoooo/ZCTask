import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static Future<void> storeToken(String token, int validity) async {
    await secureStorage.write(key: 'token', value: token);
    await secureStorage.write(key: 'validity', value: validity.toString());
  }

  static getValidity() async => await secureStorage.read(key: 'validity');

  static Future<String?> getToken() async {
    final token = await secureStorage.read(key: 'token');
    log('TOKEN: $token');
    return token;
  }

  static Future<void> deleteToken() async {
    await secureStorage.delete(key: 'token');
    await secureStorage.delete(key: 'validity');
  }
}
