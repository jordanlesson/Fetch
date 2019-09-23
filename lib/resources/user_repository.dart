import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fetch/profile.dart';
import 'package:fetch/gallery_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final Firestore _firestore;
  final FirebaseStorage _firebaseStorage;

  UserRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignin,
      Firestore firestore,
      FirebaseStorage firebaseStorage})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _firestore = firestore ?? Firestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  // Future<FirebaseUser> signInWithGoogle() async {
  //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   final FirebaseUser user =
  //       await _firebaseAuth.signInWithCredential(credential);
  //   return user;
  // }

  Future<FirebaseUser> signInWithCredentials(String email, String password) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user.user;
  }

  Future<FirebaseUser> signUp({String email, String password}) async {
    final user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user.user;
  }

  Future<bool> initializeUser({FirebaseUser userInfo, Profile dogInfo}) async {
    final user =
        await _firestore.collection("users").document(userInfo.uid).setData({
      "email": userInfo.email,
      "id": userInfo.uid,
    });

    if (dogInfo != null) {
      final dog = await _firestore.collection("dogs").add({
        "name": dogInfo.name,
        "dateOfBirth": dogInfo.dateOfBirth,
        "gender": dogInfo.gender,
        "breed": dogInfo.breed,
        "owner": userInfo.uid,
        "likes": [],
        "treats": [],
        "likeCount": 0,
        "treatCount": 0,
        "hobby": "",
        "bio": "",
      });

      List<String> photoURLs = new List<String>();
      List<String> photoPaths = new List<String>();

      for (int photoIndex = 0;
          photoIndex < dogInfo.photos.length;
          photoIndex++) {
        final storageRef = _firebaseStorage.ref().child(
            "dogs/${dog.documentID}/profilePhoto${photoIndex.toString()}.jpg");
        final StorageUploadTask photoUpload =
            storageRef.putData(dogInfo.photos[photoIndex]);
        final StorageTaskSnapshot photoUploadComplete =
            await photoUpload.onComplete;
        print(photoUploadComplete);
        if (photoUpload.isSuccessful) {
          final photoURL = await storageRef.getDownloadURL();
          final photoPath = storageRef.path;
          photoURLs.add(photoURL);
          photoPaths.add(photoPath);
          print("IS THIS GOING TO WORK");
          if (photoURLs.length == dogInfo.photos.length &&
              photoPaths.length == dogInfo.photos.length) {
            print("THIS SHOULD WORK");
            final DocumentReference dogRef =
                _firestore.collection("dogs").document("${dog.documentID}");
            dogRef.updateData({
              "id": dog.documentID,
              "photos": photoURLs,
              "photoPaths": photoPaths,
            });
            final SharedPreferences preferences =
                await SharedPreferences.getInstance();

            preferences.setString("account", dog.documentID);
            return true;
          }
        }
      }
    } else {
      return true;
    }
  }

  Future<void> deleteAccount(String userID) async {
    final user = await _firebaseAuth.currentUser();
    user.delete();
    await _firestore.collection("users").document(userID).delete();
    // final dogs = await _firestore
    //     .collection("dogs")
    //     .where("owner", isEqualTo: userID)
    //     .getDocuments();
    // if (dogs.documents.isNotEmpty) {
    //   for (DocumentSnapshot dog in dogs.documents) {
    //     dog.reference.delete();
    //     await _firebaseStorage.ref().child("dogs/$userID").delete();
    //   }
    // }
  }

  Future<void> addAccount(String userID, Profile dog) async {
    if (dog != null) {
      final dogDocument = await _firestore.collection("dogs").add({
        "name": dog.name,
        "dateOfBirth": dog.dateOfBirth,
        "gender": dog.gender,
        "breed": dog.breed,
        "photos": dog.photos,
        "owner": userID,
        "likes": [],
        "treats": [],
        "likeCount": 0,
        "treatCount": 0,
        "hobby": "",
        "bio": "",
      });

      List<String> photoURLs = new List<String>();
      List<String> photoPaths = new List<String>();

      for (int photoIndex = 0; photoIndex < dog.photos.length; photoIndex++) {
        final storageRef = _firebaseStorage.ref().child(
            "dogs/${dogDocument.documentID}/profilePhoto${photoIndex.toString()}.jpg");
        final StorageUploadTask photoUpload =
            storageRef.putData(dog.photos[photoIndex]);
        final StorageTaskSnapshot storageTask = await photoUpload.onComplete;
        if (storageTask.bytesTransferred == storageTask.totalByteCount) {
          final photoURL = await storageRef.getDownloadURL();
          final photoPath = storageRef.path;
          photoURLs.add(photoURL);
          photoPaths.add(photoPath);
          if (photoURLs.length == dog.photos.length &&
              photoPaths.length == dog.photos.length) {
            final DocumentReference dogRef = _firestore
                .collection("dogs")
                .document("${dogDocument.documentID}");
            dogRef.updateData({
              "id": dogDocument.documentID,
              "photos": photoURLs,
              "photoPaths": photoPaths,
            });
            final SharedPreferences preferences =
                await SharedPreferences.getInstance();

            preferences.setString("account", dogDocument.documentID);
          }
        }
      }
    }
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<bool> checkIfEmailExists(String email) async {
    final accountDocuments = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .limit(1)
        .getDocuments();
    final account = accountDocuments.documents;
    return account.isNotEmpty;
  }

  Future<Profile> getDogProfile(String userID) async {
    final dogProfiles = await _firestore
        .collection("dogs")
        .where("owner", isEqualTo: userID)
        .getDocuments();

    if (dogProfiles.documents.isNotEmpty && dogProfiles != null) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final preferredAccount = preferences.getString("account");

      final Map<String, dynamic> dogInfo = preferredAccount != null
          ? dogProfiles.documents
              .singleWhere((account) => account.documentID == preferredAccount)
              .data
          : dogProfiles.documents.first.data;
      final Profile dogProfile = Profile(
        name: dogInfo["name"],
        id: dogInfo["id"],
        dateOfBirth: dogInfo["dateOfBirth"].toDate(),
        breed: dogInfo["breed"],
        bio: dogInfo["bio"],
        gender: dogInfo["gender"],
        hobby: dogInfo["hobby"],
        owner: dogInfo["owner"],
        photos: dogInfo["photos"],
        photoPaths: dogInfo["photoPaths"],
        treats: dogInfo["treats"],
        likes: dogInfo["likes"],
        likeCount: dogInfo["likeCount"],
        treatCount: dogInfo["treatCount"],
      );
      return dogProfile;
    } else {
      return null;
    }
  }

  Future<Profile> fetchDog(String userID) async {
    try {
      final dogDocument =
          await _firestore.collection("dogs").document(userID).get();

      if (dogDocument.exists) {
        final Map<String, dynamic> dogInfo = dogDocument.data;

        final Profile dogProfile = Profile(
          name: dogInfo["name"],
          id: dogInfo["id"],
          dateOfBirth: dogInfo["dateOfBirth"].toDate(),
          breed: dogInfo["breed"],
          bio: dogInfo["bio"],
          gender: dogInfo["gender"],
          hobby: dogInfo["hobby"],
          owner: dogInfo["owner"],
          photos: dogInfo["photos"],
          photoPaths: dogInfo["photoPaths"],
          treats: dogInfo["treats"],
          likes: dogInfo["likes"],
          likeCount: dogInfo["likeCount"],
          treatCount: dogInfo["treatCount"],
        );
        return dogProfile;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Future<void> updateDogProfile(
      Profile dogProfile, List<Uint8List> photos) async {
    if (photos.isNotEmpty && photos != null) {
      List photoURLs = new List<dynamic>();
      List photoPaths = new List<String>();
      int photoIndex = 0;
      for (Uint8List photo in photos) {
        final storageRef = _firebaseStorage
            .ref()
            .child("dogs/${dogProfile.id}/profilePhoto$photoIndex.jpg");
        photoIndex++;
        final StorageUploadTask photoUpload = storageRef.putData(photo);
        final StorageTaskSnapshot storageTask = await photoUpload.onComplete;
        if (storageTask.bytesTransferred == storageTask.totalByteCount) {
          final photoURL = await storageRef.getDownloadURL();
          final photoPath = storageRef.path;
          photoURLs.add(photoURL);
          photoPaths.add(photoPath);
          if (photoURLs.length == photos.length &&
              photoPaths.length == photos.length) {
            final DocumentReference dogRef =
                _firestore.collection("dogs").document("${dogProfile.id}");
            return _firestore
                .collection("dogs")
                .document(dogProfile.id)
                .updateData({
              "bio": dogProfile.bio,
              "hobby": dogProfile.hobby,
              "photos": photoURLs,
              "photoPaths": photoPaths,
            });
          }
        }
      }
    } else {
      return await _firestore
          .collection("dogs")
          .document(dogProfile.id)
          .updateData({"bio": dogProfile.bio, "hobby": dogProfile.hobby});
    }
  }

  Future<Uint8List> fetchProfileImage(Profile dogProfile) async {
    final StorageReference storageRef =
        _firebaseStorage.ref().child(dogProfile.photoPaths.first);
    final Uint8List imageData = await storageRef.getData(1024 * 1024);
    return imageData;
  }

  Future<List<Uint8List>> fetchDogImages(Profile dogProfile) async {
    List<Uint8List> photos = new List<Uint8List>();
    int photoIndex = 0;
    for (dynamic photoURL in dogProfile.photos) {
      final StorageReference storageRef =
          _firebaseStorage.ref().child(dogProfile.photoPaths[photoIndex]);
      photoIndex++;
      final Uint8List imageData = await storageRef.getData(1024 * 1024);
      photos.add(imageData);
      if (photos.length == dogProfile.photos.length) {
        return photos;
      }
    }
  }
}
