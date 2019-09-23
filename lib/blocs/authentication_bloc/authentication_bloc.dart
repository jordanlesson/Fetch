import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:fetch/blocs/authentication_bloc/bloc.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:fetch/resources/notification_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;

  AuthenticationBloc(
      {@required UserRepository userRepository,
      @required NotificationRepository notificationRepository})
      : assert(userRepository != null),
        assert(notificationRepository != null),
        _userRepository = userRepository,
        _notificationRepository = notificationRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState(event.context);
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState(BuildContext context) async* {
    yield Uninitialized();
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        yield Authenticated(user);
        //_notificationRepository.initializeNotifications(context, user.uid);
      } else {
        yield Unauthenticated();
      }
    } catch (error) {
      print(error);
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    try {
    final user = await _userRepository.getUser();
    if (user != null) {
    yield Authenticated(user);
    } else {
      yield Unauthenticated();
    }
    } catch (error) {
     yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
