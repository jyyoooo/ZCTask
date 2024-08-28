import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:zoftcare_app/core/utils/colors.dart';
import 'package:zoftcare_app/presentation/login/bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LoginBloc>().add(GetVersion());
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<LoginBloc, LoginState>(
            // listenWhen: (previous, current) => current is LoginError,
            listener: (context, state) {
              if (state is LoginAuthenticated) {
                Navigator.pushReplacementNamed(context, '/postList',
                    arguments: state.user);
              } else if (state is LoginError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Zoftcares Login',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _buildEmailField(),
                        const SizedBox(height: 8),
                        _buildPasswordField(),
                        const SizedBox(height: 8),
                        // state is LoginLoading
                        //     ? const CupertinoActivityIndicator()
                        //     :
                        _buildLoginButton(context),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if (state is VersionLoaded) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text('version ${state.version}',
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        // Basic email format validation
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 4) {
          return 'Password must be at least 4 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) => CupertinoButton(
        color: primaryBlue,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final email = _emailController.text;
            final password = _passwordController.text;

            context.read<LoginBloc>().add(LoginButtonPressed(
                  email: email,
                  password: password,
                ));
          }
        },
        child: state == LoginLoading()
            ? const CupertinoActivityIndicator()
            : const Text('Login'),
      ),
    );
  }
}
