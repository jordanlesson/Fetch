import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:fetch/profile.dart';

@immutable
class LeaderboardState {
  final List<Profile> dogs;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;

  LeaderboardState({
    this.dogs,
    this.isSuccess,
    this.isFailure,
    this.isLoading,
  });

  LeaderboardState notEmpty({
    List<Profile> dogs,
  }) {
    return LeaderboardState(
      dogs: dogs,
      isSuccess: true,
      isFailure: false,
      isLoading: false,
    );
  }

  factory LeaderboardState.initial() {
    return LeaderboardState(
      dogs: new List<Profile>(),
      isSuccess: false,
      isFailure: false,
      isLoading: true,
    );
  }

  factory LeaderboardState.failure() {
    return LeaderboardState(
      dogs: new List<Profile>(),
      isSuccess: false,
      isFailure: true,
      isLoading: false,
    );
  }

}