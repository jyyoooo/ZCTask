import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:zoftcare_app/data/data_source/user_local_source.dart';
import '../../domain/entities/post.dart';

class PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSource({required this.client});

  Future<List<Post>> fetchPosts(int page, int size) async {
    try {
      final String token = await AuthRepository.getToken() ?? '';
      final response = await client.get(
        Uri.parse('https://mock-api.zoft.care/posts?page=$page&size=$size'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-key': token,
        },
      );

      if (response.statusCode == 200) {
        log('POSTS RESPONSE: ${response.statusCode}');
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        return data
            .map((post) => Post(
                  id: post['id'],
                  title: post['title'],
                  body: post['body'],
                  image: post['image'],
                ))
            .toList();
      } else {
        log('Failed to load posts: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load posts');
      }
    } catch (e, stackTrace) {
      log('Error fetching posts: $e', stackTrace: stackTrace);

      return [];
    }
  }
}
