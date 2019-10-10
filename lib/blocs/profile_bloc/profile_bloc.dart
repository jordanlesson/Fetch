import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import './bloc.dart';
import 'package:fetch/models/profile.dart';
import 'package:fetch/resources/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ProfileState get initialState => ProfileState.initial();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileStarted) {
      yield* _mapProfileStartedToState(event.userID);
    } else if (event is ProfileReloadPressed) {
      yield* _mapProfileReloadPressed(event.userID);
    }
  }

  Stream<ProfileState> _mapProfileStartedToState(String userID) async* {
    yield ProfileState.initial();
    try {
    final dogProfile = await _userRepository.getDogProfile(userID);
    
    if (dogProfile != null) {
      final profileImage = await _userRepository.fetchProfileImage(dogProfile);
      yield currentState.success(
        dog: dogProfile,
        profileImage: profileImage,
      );
    } else {
      yield ProfileState.empty();
    }
    } catch (_) {
      yield ProfileState.failure();
    }
  }

  Stream<ProfileState> _mapProfileReloadPressed(String userID) async* {
    try {
    final dogProfile = await _userRepository.getDogProfile(userID);
    if (dogProfile != null) {
      final profileImage = await _userRepository.fetchProfileImage(dogProfile);
      yield currentState.success(
        dog: dogProfile,
        profileImage: profileImage,
      );
    } else {
      yield ProfileState.empty();
    }
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}
