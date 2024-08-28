import 'package:zoftcare_app/domain/entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts(int page, int size);
}
