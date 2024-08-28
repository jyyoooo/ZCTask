
part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostEvent {
  final int page;
  final int size;

  FetchPosts({required this.page, required this.size});

  @override
  List<Object> get props => [page, size];
}
