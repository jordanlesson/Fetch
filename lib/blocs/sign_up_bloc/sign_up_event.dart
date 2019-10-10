import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:fetch/models/profile.dart';

@immutable
abstract class SignUpEvent extends Equatable {
  SignUpEvent([List props = const []]) : super(props);
}

class EmailChanged extends SignUpEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

}

class PasswordChanged extends SignUpEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

}

class NameChanged extends SignUpEvent {
  final String name;

  NameChanged({@required this.name}) : super([name]);
}

class GenderChanged extends SignUpEvent {
  final String gender;

  GenderChanged({@required this.gender}) : super([gender]);
}

class PhotosChanged extends SignUpEvent {
  final List<Uint8List> photos;

  PhotosChanged({@required this.photos}) : super([photos]);
}

class BreedChanged extends SignUpEvent {
  final String breed;

  BreedChanged({@required this.breed}) : super([breed]);
}

class DateOfBirthChanged extends SignUpEvent {
  final DateTime dateOfBirth;

  DateOfBirthChanged({@required this.dateOfBirth}) : super([dateOfBirth]);
}

class CheckIfEmailExistsPressed extends SignUpEvent {
  final String email;

  CheckIfEmailExistsPressed({@required this.email}) : super([email]);
}

class SignUpFinished extends SignUpEvent {
  final String email;
  final String password;
  final Profile dogInfo;
  final BuildContext context;

  SignUpFinished({@required this.email, @required this.password, @required this.dogInfo, @required this.context}) : super([email, password, dogInfo, context]);
}

class DogAdded extends SignUpEvent {
  final FirebaseUser user;
  final Profile dogInfo;

  DogAdded({@required this.user, @required this.dogInfo}) : super([user, dogInfo]);
}

class Submitted extends SignUpEvent {
  final String email;
  final String password;
  final DateTime dateOfBirth;
  final String name;
  final String gender;
  final String breed;
  final List<Uint8List> photos;

  Submitted({@required this.email, @required this.password, @required this.dateOfBirth, @required this.gender, @required this.breed, @required this.name, @required this.photos})
      : super([email, password, dateOfBirth, gender, breed, name, photos]);
  }