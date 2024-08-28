import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:zoftcare_app/data/models/user_model.dart';

class UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSource(this.client);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('https://mock-api.zoft.care/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      log('RESPONSE CODE: ${response.statusCode}');

      if (response.statusCode == 200) {
        log('LOG IN RESPONSE: ${response.body}');
        final data = jsonDecode(response.body)['data'];
        return UserModel.fromJson(data);
      } else {
        log('Failed to login: ${response.body}');
        throw Exception(
            'Failed to login. Server responded with status code ${response.statusCode}.');
      }
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      throw Exception(
          'Failed to login due to client error. Please check your internet connection.');
    } on FormatException catch (e) {
      log('FormatException: ${e.message}');
      throw Exception('Failed to parse response data. Please try again later.');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<String> getVersion() async {
    try {
      final response = await client.get(
        Uri.parse('https://mock-api.zoft.care/version'),
      );
      log("VERSION STATUS: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String version = data['data']['version'].toString();
        log("VERSION: $version");
        return version;
      } else {
        log('Failed to get version: ${response.body}');
        throw Exception(
            'Failed to get version. Server responded with status code ${response.statusCode}.');
      }
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      throw Exception(
          'Failed to get version due to client error. Please check your internet connection.');
    } on FormatException catch (e) {
      log('FormatException: ${e.message}');
      throw Exception('Failed to parse response data. Please try again later.');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}
