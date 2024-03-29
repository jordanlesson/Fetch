import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class Uninitialized extends AuthenticationState {
  // @override
  // String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {
  final FirebaseUser user;

  Authenticated(this.user) : super([user]);

  // @override
  // String toString() => 'Authenticated { displayName: ${user.displayName} }';
}

class Unauthenticated extends AuthenticationState {
  // @override
  // String toString() => 'Unauthenticated';
}