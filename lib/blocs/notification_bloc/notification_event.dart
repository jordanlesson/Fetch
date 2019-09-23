import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  NotificationEvent([List props = const <dynamic>[]]) : super(props);
}

class UserLoggedIn extends NotificationEvent {
  final BuildContext context;

  UserLoggedIn({@required this.context}) : super([context]);
}

class NotificationReceived extends NotificationEvent {
  
}
