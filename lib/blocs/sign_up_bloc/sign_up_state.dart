import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
class SignUpState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isDogNameValid;
  final bool isDogDateOfBirthValid;
  final bool isGenderValid;
  final bool isBreedValid;
  final bool isPhotosValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final FirebaseUser user;

  // bool get isFormValid => isEmailValid && isPasswordValid;

  SignUpState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isDogNameValid,
    @required this.isDogDateOfBirthValid,
    @required this.isGenderValid,
    @required this.isBreedValid,
    @required this.isPhotosValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    this.user
  });

  factory SignUpState.empty() {
    return SignUpState(
      isEmailValid: false,
      isPasswordValid: false,
      isBreedValid: false,
      isDogNameValid: false,
      isDogDateOfBirthValid: false,
      isGenderValid: false,
      isPhotosValid: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SignUpState.loading() {
    return SignUpState(
      isEmailValid: true,
      isPasswordValid: true,
      isBreedValid: true,
      isDogNameValid: true,
      isDogDateOfBirthValid: true,
      isGenderValid: true,
      isPhotosValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SignUpState.failure() {
    return SignUpState(
      isEmailValid: true,
      isPasswordValid: true,
      isBreedValid: true,
      isDogNameValid: true,
      isDogDateOfBirthValid: true,
      isGenderValid: true,
      isPhotosValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  SignUpState success({
    FirebaseUser user,
  }) {
    return SignUpState(
      isEmailValid: true,
      isPasswordValid: true,
      isBreedValid: true,
      isDogNameValid: true,
      isDogDateOfBirthValid: true,
      isGenderValid: true,
      isPhotosValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      user: user,
    );
  }

  SignUpState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isBreedValid,
    bool isDogNameValid,
    bool isDogDateOfBirthValid,
    bool isGenderValid,
    bool isPhotosValid,
    
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isBreedValid: isBreedValid,
      isDogNameValid: isDogNameValid,
      isDogDateOfBirthValid: isDogDateOfBirthValid,
      isGenderValid: isGenderValid,
      isPhotosValid: isPhotosValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  SignUpState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isBreedValid,
    bool isDogNameValid,
    bool isDogDateOfBirthValid,
    bool isGenderValid,
    bool isPhotosValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return SignUpState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isBreedValid: isBreedValid ?? this.isBreedValid,
      isDogDateOfBirthValid: isDogDateOfBirthValid ?? this.isDogDateOfBirthValid,
      isDogNameValid: isDogNameValid ?? this.isDogNameValid,
      isGenderValid: isGenderValid ?? this.isGenderValid,
      isPhotosValid: isPhotosValid ?? this.isPhotosValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  // @override
  // String toString() {
  //   return '''SignUpState {
  //     isEmailValid: $isEmailValid,
  //     isPasswordValid: $isPasswordValid,
  //     isSubmitting: $isSubmitting,
  //     isSuccess: $isSuccess,
  //     isFailure: $isFailure,
  //   }''';
  // }
}