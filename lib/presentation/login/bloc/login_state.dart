part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class VersionLoaded extends LoginState {
  final String version;

  VersionLoaded({required this.version});
}


class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginAuthenticated extends LoginState {
  final User? user;
  final String? token;

  LoginAuthenticated(this.token, [this.user]);
}

class LoginUnauthenticated extends LoginState {
  final String message;
  LoginUnauthenticated({required this.message});
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object> get props => [message];
}
