import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  ProfileEvent([List props = const []]) : super(props);
}

class ProfileStarted extends ProfileEvent {
  final String userID;

  ProfileStarted({@required this.userID})
      : super([userID]);
}

class ProfileReloadPressed extends ProfileEvent {
   final String userID;

  ProfileReloadPressed({@required this.userID})
      : super([userID]);

}
