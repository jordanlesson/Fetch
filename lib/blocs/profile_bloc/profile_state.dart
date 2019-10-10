import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:fetch/models/profile.dart';

@immutable
class ProfileState{
  final Profile dogProfile;
  final Uint8List profileImage;
  final bool isEmpty;
  final bool isLoading;

  ProfileState({
    @required this.dogProfile,
    @required this.isEmpty,
    @required this.profileImage,
    @required this.isLoading,
  });

  factory ProfileState.initial() {
    return ProfileState(
      dogProfile: null,
      profileImage: null,
      isEmpty: true,
      isLoading: true,
    );
  }

  

  ProfileState success({
    Profile dog,
    Uint8List profileImage,
  }) {
    return ProfileState(
      dogProfile: dog,
      profileImage: profileImage,
      isEmpty: false,
      isLoading: false,
    );
  }

  factory ProfileState.failure() {
    return ProfileState(
      dogProfile: null,
      profileImage: null,
      isEmpty: true,
      isLoading: false,
    );
  }

  factory ProfileState.loading() {
    return ProfileState(
      dogProfile: null,
      profileImage: null,
      isEmpty: true,
      isLoading: true,
    );
  }

  factory ProfileState.empty() {
    return ProfileState(
      dogProfile: null,
      profileImage: null,
      isEmpty: true,
      isLoading: false,
    );
  }

}