import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';
import 'package:fetch/resources/dog_repository.dart';
import 'package:fetch/models/profile.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final DogRepository _dogRepository;

  FeedBloc({@required DogRepository dogRepository})
      : assert(dogRepository != null),
        _dogRepository = dogRepository;

  @override
  FeedState get initialState => FeedState.initial();

  @override
  Stream<FeedState> mapEventToState(
    FeedEvent event,
  ) async* {
    if (event is FeedStarted) {
      yield* _mapFeedStartedToState(event.currentUser, event.swipedDogs, event.swipedCount);
    } else if (event is FeedEmptied) {
      yield* _mapFeedEmptiedToState();
    } else if (event is FeedRanLow) {
      yield* _mapFeedRanLowToState(event.dogs, event.swipedDogs, event.currentUser, event.swipedCount);
    } else if (event is ProfileLiked) {
      yield* _mapProfileLikedToState(event.dogs, event.currentUser, event.swipedDogs, event.swipedCount);
    } else if (event is ProfileTreated) {
      yield* _mapProfileTreatedToState(event.dogs, event.currentUser, event.swipedDogs, event.swipedCount);
    } else if (event is ProfileDisliked) {
      yield* _mapProfileDislikedToState(event.dogs, event.swipedDogs, event.swipedCount);
    } else if (event is FeedRewinded) {
      yield* _mapFeedRewindedToState(event.dogs, event.swipedDogs, event.currentUser, event.swipedCount);
    }
    // else if (event is FeedLoaded) {
    //   yield* _mapFeedLoadedToState(event.dogs);
    // }
  }

  Stream<FeedState> _mapFeedEmptiedToState() async* {
    yield currentState.empty(
        swipedDogs: new List<Profile>(),
      );
  }

  Stream<FeedState> _mapFeedStartedToState(String currentUser, List<Profile> swipedDogs, int swipedCount) async* {
    yield FeedState.initial();
    final List<Profile> dogs = await _dogRepository.fetchDogProfiles(currentUser, swipedDogs);
    if (dogs == null) {
      print("Feed Loading was a Failure");
      yield FeedState.failure();
    } else if (dogs.isNotEmpty) {

      yield currentState.notEmpty(
        dogs: dogs,
        swipedDogs: new List<Profile>(),
        swipedCount: 0,
      );
    } else if (dogs.isEmpty) {
      yield currentState.empty(
        swipedDogs: new List<Profile>(),
      );
    }
  }

  Stream<FeedState> _mapFeedRanLowToState(
      List<Profile> dogProfiles, List<Profile> swipedDogs, String currentUser, int swipedCount) async* {
    try {
      final List<Profile> dogsAdded = await _dogRepository.fetchDogProfiles(currentUser, swipedDogs);
      if (dogsAdded.isNotEmpty) {
        List<Profile> dogs = (dogProfiles + dogsAdded).toSet().toList();
        yield currentState.notEmpty(
          dogs: dogs,
          swipedDogs: swipedDogs,
          swipedCount: swipedCount,

        );
      } else {
        yield currentState.empty(
        swipedDogs: swipedDogs
      );
      }
    } catch (_) {
      yield FeedState.failure();
    }
  }

  Stream<FeedState> _mapProfileLikedToState(List<Profile> dogProfiles,
      String currentUser, List<Profile> swipedDogs, int swipedCount) async* {
    try {
      final dog = dogProfiles.first;
      List<Profile> swipedDogProfiles = new List<Profile>.from(swipedDogs);
      swipedDogProfiles.add(dog);
      dogProfiles.removeAt(0);

      if (dogProfiles.isNotEmpty) {
        yield currentState.notEmpty(
          dogs: dogProfiles,
          swipedDogs: swipedDogProfiles,
          swipedCount: swipedCount++,
        );
      } else {
        yield currentState.empty(
        swipedDogs: swipedDogProfiles
      );
      }

      await _dogRepository.likeDogProfile(currentUser, dog);
    } catch (_) {
      yield FeedState.failure();
    }
  }

  Stream<FeedState> _mapProfileTreatedToState(List<Profile> dogProfiles,
      String currentUser, List<Profile> swipedDogs, int swipedCount) async* {
    try {
      final dog = dogProfiles[0];
      List<Profile> swipedDogProfiles = new List<Profile>.from(swipedDogs);
      swipedDogProfiles.add(dog);
      dogProfiles.removeAt(0);

      if (dogProfiles.isNotEmpty) {
        yield currentState.notEmpty(
          dogs: dogProfiles,
          swipedDogs: swipedDogProfiles,
          swipedCount: swipedCount++,
        );
      } else {
        yield currentState.empty(
        swipedDogs: swipedDogProfiles
      );;
      }
      await _dogRepository.treatDogProfile(currentUser, dog);
    } catch (_) {
      yield FeedState.failure();
    }
  }

  Stream<FeedState> _mapProfileDislikedToState(
      List<Profile> dogProfiles, List<Profile> swipedDogs, int swipedCount) async* {
    final dog = dogProfiles.first;

    List<Profile> swipedDogProfiles = new List<Profile>.from(swipedDogs);
    swipedDogProfiles.add(dog);

    dogProfiles.removeAt(0);

    if (dogProfiles.isNotEmpty) {
      yield currentState.notEmpty(
        dogs: dogProfiles,
        swipedDogs: swipedDogProfiles,
        swipedCount: swipedCount++,
      );
    } else {
      yield currentState.empty(
        swipedDogs: swipedDogProfiles
      );
    }
  }

  Stream<FeedState> _mapFeedRewindedToState(List<Profile> dogs, List<Profile> swipedDogs, String currentUser, int swipedCount) async* {
    try {
      await _dogRepository.rewindDogProfile(currentUser, swipedDogs.first);

      List<Profile> dogProfiles = new List<Profile>.from(dogs);
      List<Profile> swipedDogProfiles = new List<Profile>.from(swipedDogs);
      final Profile rewindedDog = swipedDogProfiles.removeLast();

      dogProfiles.insert(0, rewindedDog);

      yield currentState.notEmpty(
        dogs: dogProfiles,
        swipedDogs: swipedDogProfiles,
        swipedCount: swipedCount++,
      );
      
    } catch (error) {
      print(error);
      yield FeedState.failure();
    }
  }
}
