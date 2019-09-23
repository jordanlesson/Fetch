import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NotificationState extends Equatable {
  NotificationState([List props = const <dynamic>[]]) : super(props);
}

class NotificationsUninitialized extends NotificationState {

}

class NotificationExists extends NotificationState {

}

class NotificationEmpty extends NotificationState {

}
