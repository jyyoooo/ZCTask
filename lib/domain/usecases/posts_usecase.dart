// lib/domain/usecases/get_posts_usecase.dart

import 'package:zoftcare_app/domain/entities/post.dart';
import 'package:zoftcare_app/domain/repository/posts_repository.dart';

class PostsUseCase {
  final PostRepository repository;

  PostsUseCase(this.repository);

  Future<List<Post>> call(int page, int size) async {
    return await repository.getPosts(page, size);
  }
}
