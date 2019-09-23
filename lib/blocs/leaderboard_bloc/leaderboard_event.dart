import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LeaderboardEvent extends Equatable {
  LeaderboardEvent([List props = const <dynamic>[]]) : super(props);
}

class LeaderboardStarted extends LeaderboardEvent {

}

class OnBreedFilterChanged extends LeaderboardEvent {
  
  final String breed;

  OnBreedFilterChanged({@required this.breed}) : super([breed]);

}
