import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

}

class Submitted extends LoginEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password})
      : super([email, password]);

}

class LoginWithGooglePressed extends LoginEvent {

}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;

  LoginWithCredentialsPressed({@required this.email, @required this.password, @required this.context})
      : super([email, password, context]);

}

class CheckIfEmailExistsPressed extends LoginEvent {
  final String email;

  CheckIfEmailExistsPressed({@required this.email})
      : super([email]);

}