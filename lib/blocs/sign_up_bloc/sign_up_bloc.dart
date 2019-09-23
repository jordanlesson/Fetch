import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:fetch/blocs/login_bloc/login_event.dart' as prefix0;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fetch/blocs/sign_up_bloc/sign_up_event.dart';
import 'package:fetch/blocs/sign_up_bloc/sign_up_state.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:fetch/resources/notification_repository.dart';
import 'package:fetch/utils/validators.dart';

import '../../profile.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;

  SignUpBloc(
      {@required UserRepository userRepository,
      NotificationRepository notificationRepository})
      : assert(userRepository != null),
        assert(notificationRepository != null),
        _userRepository = userRepository,
        _notificationRepository = notificationRepository;

  @override
  SignUpState get initialState => SignUpState.empty();

  @override
  Stream<SignUpState> transform(
    Stream<SignUpEvent> events,
    Stream<SignUpState> Function(SignUpEvent event) next,
  ) {
    final observableStream = events as Observable<SignUpEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounce(Duration(milliseconds: 1));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is DateOfBirthChanged) {
      yield* _mapDateOfBirthChangedToState(event.dateOfBirth);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is BreedChanged) {
      yield* _mapBreedChangedToState(event.breed);
    } else if (event is PhotosChanged) {
      yield* _mapPhotosChangedToState(event.photos);
    } else if (event is CheckIfEmailExistsPressed) {
      yield* _mapCheckIfEmailExistsPressedToState(email: event.email);
    } else if (event is SignUpFinished) {
      yield* _mapSignUpFinishedToState(
          email: event.email,
          password: event.password,
          dogInfo: event.dogInfo,
          context: event.context);
    } else if (event is DogAdded) {
      yield* _mapDogAddedToState(user: event.user, dogInfo: event.dogInfo);
    }
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<SignUpState> _mapNameChangedToState(String name) async* {
    yield currentState.update(
        isDogNameValid: name != null && name.length < 20 && name.isNotEmpty);
  }

  Stream<SignUpState> _mapGenderChangedToState(String gender) async* {
    yield currentState.update(
      isGenderValid: gender != null,
    );
  }

  Stream<SignUpState> _mapDateOfBirthChangedToState(
      DateTime dateOfBirth) async* {
    yield currentState.update(
      isDogDateOfBirthValid: dateOfBirth != null,
    );
  }

  Stream<SignUpState> _mapBreedChangedToState(String breed) async* {
    yield currentState.update(
      isBreedValid: breed != null,
    );
  }

  Stream<SignUpState> _mapPhotosChangedToState(List<Uint8List> photos) async* {
    yield currentState.update(
      isPhotosValid: photos != null && photos.isNotEmpty,
    );
  }

  Stream<SignUpState> _mapCheckIfEmailExistsPressedToState({
    String email,
  }) async* {
    yield SignUpState.loading();
    try {
      final emailExists = await _userRepository.checkIfEmailExists(email);
      if (emailExists) {
        yield SignUpState.failure();
      } else {
        yield currentState.success();
      }
    } catch (_) {
      yield SignUpState.failure();
    }
  }

  Stream<SignUpState> _mapSignUpFinishedToState({
    String email,
    String password,
    Profile dogInfo,
    BuildContext context,
  }) async* {
    yield SignUpState.loading();
    try {
      final newUser = await _userRepository.signUp(
        email: email,
        password: password,
      );
      final userInitialized = await _userRepository.initializeUser(
          userInfo: newUser, dogInfo: dogInfo);
      if (userInitialized) {
        yield currentState.success(user: newUser);
        //_notificationRepository.initializeNotifications(context, newUser.uid);
      } else {
        yield SignUpState.failure();
      }
    } catch (error) {
      print(error);
      yield SignUpState.failure();
    }
  }

  Stream<SignUpState> _mapDogAddedToState({
    FirebaseUser user,
    Profile dogInfo,
  }) async* {
    yield SignUpState.loading();
    try {
      final dogInitialized = await _userRepository.initializeUser(
          userInfo: user, dogInfo: dogInfo);
      if (dogInitialized) {
        yield currentState.success(
          user: user,
        );
      } else {
        yield SignUpState.failure();
      }
    } catch (error) {
      print(error);
      yield SignUpState.failure();
    }
  }
}
