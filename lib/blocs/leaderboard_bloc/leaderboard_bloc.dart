import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fetch/models/profile.dart';
import 'package:fetch/resources/dog_repository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final DogRepository _dogRepository;

  LeaderboardBloc({@required DogRepository dogRepository})
      : assert(dogRepository != null),
        _dogRepository = dogRepository;

  @override
  LeaderboardState get initialState => LeaderboardState.initial();

  @override
  Stream<LeaderboardState> mapEventToState(
    LeaderboardEvent event,
  ) async* {
    if (event is LeaderboardStarted) {
      yield* _mapLeaderboardStartedToState();
    } else if (event is OnBreedFilterChanged) {
      yield* _mapOnBreedFilterChangedToState(event.breed);
    }
  }

  Stream<LeaderboardState> _mapLeaderboardStartedToState() async* {
    List<Profile> dogs = await _dogRepository.fetchLeaderboardDogs(null);

    if (dogs != null) {
      yield currentState.notEmpty(
        dogs: dogs
      );
    } else {
      yield LeaderboardState.failure();
    }
  }

  Stream<LeaderboardState> _mapOnBreedFilterChangedToState(String breed) async* {

    yield LeaderboardState.initial();

    List<Profile> dogs = await _dogRepository.fetchLeaderboardDogs(breed);

    if (dogs != null) {
      yield currentState.notEmpty(
        dogs: dogs
      );
    } else {
      yield LeaderboardState.failure();
    }
  }

}
