import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:fetch/models/profile.dart';

@immutable
abstract class FeedEvent extends Equatable {
  FeedEvent([List props = const []]) : super(props);
}

class FeedEmptied extends FeedEvent {

  // @override
  // String toString() => 'Feed Emptied';
}

class FeedRanLow extends FeedEvent {

  final List<Profile> dogs;
  final List<Profile> swipedDogs;
  final String currentUser;
  final int swipedCount;

  FeedRanLow({@required this.dogs, @required this.swipedDogs, @required this.currentUser, @required this.swipedCount})
      : super([dogs, swipedDogs, currentUser]);

  // @override
  // String toString() => 'Feed Ran Low';
}

class FeedStarted extends FeedEvent {

  final String currentUser;
  final List<Profile> swipedDogs;
  final int swipedCount;

  FeedStarted({@required this.currentUser, @required this.swipedDogs, @required this.swipedCount})
      : super([currentUser, swipedDogs]);
  // @override
  // String toString() => 'Feed Loaded';
}

class ProfileLiked extends FeedEvent {
  final List<Profile> dogs;
  final String currentUser;
  final List<Profile> swipedDogs;
  final int swipedCount;

  ProfileLiked({@required this.dogs, @required this.currentUser, @required this.swipedDogs, @required this.swipedCount})
      : super([dogs, swipedDogs, currentUser]);

  // @override
  // String toString() => 'Dog Liked';
}

class ProfileTreated extends FeedEvent {
  final List<Profile> dogs;
  final String currentUser;
  final List<Profile> swipedDogs;
  final int swipedCount;

  ProfileTreated({@required this.dogs, @required this.currentUser, @required this.swipedDogs, @required this.swipedCount})
      : super([dogs, swipedDogs, currentUser]);

  // @override
  // String toString() => 'Dog Treated';
}

class ProfileDisliked extends FeedEvent {
  final List<Profile> dogs;
  final List<Profile> swipedDogs;
  final int swipedCount;

  ProfileDisliked({@required this.dogs, @required this.swipedDogs, @required this.swipedCount})
      : super([dogs, swipedDogs]);

  // @override
  // String toString() => 'Dog Disliked';
}

class FeedRewinded extends FeedEvent {
  final List<Profile> dogs;
  final String currentUser;
  final List<Profile> swipedDogs;
  final int swipedCount;

  FeedRewinded({@required this.dogs, @required this.currentUser, @required this.swipedDogs, @required this.swipedCount})
      : super([dogs, swipedDogs, currentUser]);

  // @override
  // String toString() => 'Dog Treated';
}