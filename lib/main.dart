import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zoftcare_app/data/data_source/post_remote_source.dart';
import 'package:zoftcare_app/data/data_source/user_remote_source.dart';
import 'package:zoftcare_app/data/repository_impl/post_repository_impl.dart';
import 'package:zoftcare_app/data/repository_impl/user_repository_impl.dart';
import 'package:zoftcare_app/domain/usecases/login_usecase.dart';
import 'package:zoftcare_app/domain/usecases/posts_usecase.dart';
import 'package:zoftcare_app/domain/usecases/version_usecase.dart';
import 'package:zoftcare_app/presentation/login/bloc/login_bloc.dart';
import 'package:zoftcare_app/presentation/login/splash_screen.dart';
import 'package:zoftcare_app/presentation/posts/bloc/post_bloc.dart';
import 'package:zoftcare_app/presentation/posts/post_list_screen.dart';
import 'presentation/login/login_screen.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(
              versionUseCase: GetVersionUseCase(
                  UserRepositoryImpl(UserRemoteDataSource(http.Client()))),
              secureStorage: const FlutterSecureStorage(),
              loginUseCase: LoginUseCase(
                  UserRepositoryImpl(UserRemoteDataSource(http.Client())))),
        ),
        BlocProvider(
          create: (context) => PostBloc(
              getPostsUseCase: PostsUseCase(PostRepositoryImpl(
                  remoteDataSource:
                      PostRemoteDataSource(client: http.Client())))),
        )
      ],
      child: MaterialApp(
        key: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Zoftcare Task',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        // home: LoginScreen(),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/postList': (context) => const PostListScreen(),
        },
      ),
    );
  }
}
