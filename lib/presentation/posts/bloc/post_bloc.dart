import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zoftcare_app/domain/entities/post.dart';
import 'package:zoftcare_app/domain/usecases/posts_usecase.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostsUseCase getPostsUseCase;

  PostBloc({required this.getPostsUseCase}) : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final List<Post> posts = await getPostsUseCase(event.page, event.size);
      log(posts.toString());
      emit(PostLoaded(
          posts: posts, currentPage: event.page, hasReachedMax: false));
    } catch (e) {
      emit(const PostError(message: 'Failed to fetch posts'));
    }
  }
}
