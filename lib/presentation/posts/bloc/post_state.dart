// lib/presentation/bloc/post/post_state.dart

part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  final int currentPage;  
  final bool hasReachedMax;  

  const PostLoaded({
    required this.posts,
    required this.currentPage,
    required this.hasReachedMax,
  });

  PostLoaded copyWith({
    List<Post>? posts,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, currentPage, hasReachedMax];
}

class PostError extends PostState {
  final String message;

  const PostError({required this.message});

  @override
  List<Object> get props => [message];
}
