part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashLogin extends LoginEvent {}

class GetVersion extends LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SessionStartEvent extends LoginEvent {
  final int validity;

  SessionStartEvent({required this.validity});
}
