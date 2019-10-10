import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fetch/blocs/login_bloc/login_event.dart';
import 'package:fetch/blocs/login_bloc/login_state.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:fetch/utils/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transform(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounce(Duration(milliseconds: 1));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } 
    // else if (event is LoginWithGooglePressed) {
    //   yield* _mapLoginWithGooglePressedToState();
    // } 
    else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
        context: event.context
      );
    } else if (event is CheckIfEmailExistsPressed) {
      yield* _mapCheckIfEmailExistsPressedToState(email: event.email);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  // Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
  //   try {
  //     final user = await _userRepository.signInWithGoogle();
  //     yield currentState.success(
  //       user: user,
  //     );
  //   } catch (_) {
  //     yield LoginState.failure();
  //   }
  // }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
    BuildContext context,
  }) async* {
    yield LoginState.loading();
    try {
      final user = await _userRepository.signInWithCredentials(email, password);
      if (user != null) {
        yield currentState.success(
          user: user,
        );
      }
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapCheckIfEmailExistsPressedToState({
    String email,
  }) async* {
    yield LoginState.loading();
    try {
      final emailExists = await _userRepository.checkIfEmailExists(email);
      if (emailExists) {
        yield currentState.success(
          user: null,
        );
      } else {
        yield LoginState.failure();
      }
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
