import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zoftcare_app/data/data_source/user_local_source.dart';
import 'package:zoftcare_app/domain/entities/user.dart';
import 'package:zoftcare_app/presentation/login/bloc/login_bloc.dart';
import 'package:zoftcare_app/domain/entities/post.dart';
import 'bloc/post_bloc.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  static const _pageSize = 10;

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPosts(pageKey);
    });
    log('called fetch');
  }

  Future<void> _fetchPosts(int pageKey) async {
    BlocProvider.of<PostBloc>(context)
        .add(FetchPosts(page: pageKey, size: _pageSize));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.settingsOf(context)?.arguments as User?;

    return Scaffold(
      appBar: AppBar(
        actions: [
          CupertinoButton(
              child: const Text('Logout'),
              onPressed: () {
                context.read<LoginBloc>().add(Logout());
              })
        ],
        title: Text('${user?.firstName ?? ''} ${user?.lastName ?? 'Posts'}'),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        // listenWhen: (previous, current) => current is LoginUnauthenticated,
        listener: (context, state) {
          if (state is LoginUnauthenticated) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
        child: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostLoaded) {
              final isLastPage = state.posts.length < _pageSize;
              if (isLastPage) {
                _pagingController.appendLastPage(state.posts);
              } else {
                final nextPageKey = state.currentPage + 1;
                _pagingController.appendPage(state.posts, nextPageKey);
              }
            } else if (state is PostError) {
              _pagingController.error = state.message;
            }
          },
          child: PagedListView<int, Post>(
            physics: const BouncingScrollPhysics(),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Post>(
              noItemsFoundIndicatorBuilder: (context) {
                return const Center(child: Text('No posts available'));
              },
              itemBuilder: (context, item, index) => _buildPostItem(item),
              firstPageErrorIndicatorBuilder: (context) => const Center(
                child: Text('Something went wrong. Please try again.'),
              ),
              newPageErrorIndicatorBuilder: (context) => const Center(
                child: Text('Something went wrong. Please try again.'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostItem(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.grey),
        ),
        title: Text(
          post.title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(post.body),
        leading: Image.network(
          post.image,
          loadingBuilder: (context, child, loadingProgress) =>
              const CupertinoActivityIndicator(),
          errorBuilder: (context, error, stackTrace) =>
              const Icon(CupertinoIcons.photo),
        ),
      ),
    );
  }
}
