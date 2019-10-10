import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:fetch/models/profile.dart';

@immutable
class FeedState {
  final List<Profile> dogs;
  final List<Profile> swipedDogs;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;

  FeedState({
    this.dogs,
    this.swipedDogs,
    this.isSuccess,
    this.isFailure,
    this.isLoading,
  });

  FeedState loading({
    List<Profile> dogs,
    List<Profile> swipedDogs,
  }) {
    return FeedState(
      dogs: dogs,
      swipedDogs: swipedDogs,
      isSuccess: false,
      isFailure: false,
      isLoading: true,
    );
  }

  FeedState notEmpty({
    List<Profile> dogs,
    List<Profile> swipedDogs,
  }) {
    return FeedState(
      dogs: dogs,
      swipedDogs: swipedDogs,
      isSuccess: true,
      isFailure: false,
      isLoading: false,
    );
  }

  FeedState empty({
    List<Profile> swipedDogs,
  }) {
    return FeedState(
      dogs: new List<Profile>(),
      swipedDogs: swipedDogs,
      isSuccess: true,
      isFailure: false,
      isLoading: false,
    );
  }

  factory FeedState.initial() {
    return FeedState(
      dogs: new List<Profile>(),
      swipedDogs: new List<Profile>(),
      isSuccess: false,
      isFailure: false,
      isLoading: true,
    );
  }

  factory FeedState.failure() {
    return FeedState(
      dogs: new List<Profile>(),
      swipedDogs: new List<Profile>(),
      isSuccess: false,
      isFailure: true,
      isLoading: false,
    );
  }

}


// class FeedListEmpty extends FeedState {

//   @override
//   String toString() => 'No Dogs Available';
// }

// class FeedListLoading extends FeedState {
//   @override
//   String toString() => 'Fetching Dogs';
// }

// class FeedListNotEmpty extends FeedState {

//   final List<Profile> dogs;

//   FeedListNotEmpty(this.dogs) : super([dogs]);

//   @override
//   String toString() => 'Dogs Are Available';
// }

// class FeedListFailure extends FeedState {
//   @override
//   String toString() => 'Failure Loading Dogs';
// }



