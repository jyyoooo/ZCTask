import 'package:zoftcare_app/data/data_source/post_remote_source.dart';
import 'package:zoftcare_app/domain/entities/post.dart';
import 'package:zoftcare_app/domain/repository/posts_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Post>> getPosts(int page, int size) async {
    return await remoteDataSource.fetchPosts(page, size);
  }
}
