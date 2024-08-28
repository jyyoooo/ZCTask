import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zoftcare_app/data/data_source/user_local_source.dart';
import 'package:zoftcare_app/domain/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:zoftcare_app/domain/entities/user.dart';
import 'package:zoftcare_app/domain/usecases/version_usecase.dart';
part './login_event.dart';
part './login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final FlutterSecureStorage secureStorage;
  final GetVersionUseCase versionUseCase;
  Timer? _sessionTimer;
  // int validity = 20000;

  LoginBloc({
    required this.secureStorage,
    required this.loginUseCase,
    required this.versionUseCase,
  }) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onloginButtonPressed);
    on<SplashLogin>(_onSplashLogin);
    on<GetVersion>(_onGetVersion);
  }

  FutureOr<void> _onloginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    log('emitted loading');
    try {
      final User user = await loginUseCase(event.email, event.password);

      emit(LoginAuthenticated(user.token));
      AuthRepository.storeToken(user.token, user.validity);
      _sessionTimer?.cancel();
      final validity = await AuthRepository.getValidity();
      _sessionTimer = Timer(Duration(milliseconds: int.parse(validity)), () async {
        AuthRepository.deleteToken();
        add(SplashLogin());
      });
    } catch (e) {
      emit(LoginError('Login failed. Please try again.'));
    }
  }

  FutureOr<void> _onSplashLogin(
      SplashLogin event, Emitter<LoginState> emit) async {
    final String? token = await AuthRepository.getToken();
    // log("TOKEN: $token");
    if (token != null && token.isNotEmpty) {
      emit(LoginAuthenticated(token));
      _sessionTimer?.cancel();
      final validity = await AuthRepository.getValidity();
      _sessionTimer =
          Timer(Duration(milliseconds: int.parse(validity)), () async {
        AuthRepository.deleteToken();
        add(SplashLogin());
      });
    } else {
      emit(LoginUnauthenticated(message: 'Session expired.'));
    }
  }

  @override
  Future<void> close() {
    _sessionTimer?.cancel();
    return super.close();
  }

  FutureOr<void> _onGetVersion(
      GetVersion event, Emitter<LoginState> emit) async {
    emit(LoginInitial());
    final String version = await versionUseCase.getVersion();
    emit(VersionLoaded(version: version));
  }
}
