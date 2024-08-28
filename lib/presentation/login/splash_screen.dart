import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoftcare_app/data/data_source/user_local_source.dart';
import 'package:zoftcare_app/main.dart';
import 'package:zoftcare_app/presentation/login/bloc/login_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // _checkAuthStatus();
    context.read<LoginBloc>().add(SplashLogin());
  }

  // Future<void> _checkAuthStatus() async {
  //   final token = await AuthRepository.getToken();
  //   if (token != null) {
  //     Navigator.pushReplacementNamed(context, '/postList');
  //   } else {
  //     await AuthRepository.deleteToken();
  //     Navigator.pushReplacementNamed(context, '/login',
  //         arguments: {'message': 'Session expired'});
  //     WidgetsBinding.instance.addPostFrameCallback((_) =>
  //         scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
  //             content: Text('Session expired. Please log in again.'))));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginAuthenticated) {
            Navigator.pushReplacementNamed(context, '/postList');
          } else if(state is LoginUnauthenticated){
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Zoftcares',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            CupertinoActivityIndicator(),
          ],
        )),
      ),
    );
  }
}
