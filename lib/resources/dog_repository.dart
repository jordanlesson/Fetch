import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DogRepository {
  final Firestore _firestore;

  DogRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Future<void> likeDogProfile(String currentUser, Profile dogProfile) async {
    final DocumentReference dogReference =
        _firestore.collection("dogs").document(dogProfile.id);
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot dog = await tx.get(dogReference);
      if (dog.exists) {
        final List<String> likes = List.from(dog.data["likes"]);
        likes.add(currentUser);
        final likeCount = likes.length;
        return await tx.update(dogReference, {"likes": likes, "likeCount": likeCount});
      }
    });
  }

  Future<void> treatDogProfile(String currentUser, Profile dogProfile) async {
    final dogReference = _firestore.collection("dogs").document(dogProfile.id);
    _firestore.runTransaction((Transaction tx) async {
      final dog = await tx.get(dogReference);
      if (dog.exists) {
        final List<String> treats = List.from(dog.data["treats"]);
        treats.add(currentUser);
        final treatCount = treats.length;
        return await tx.update(dogReference, {"treats": treats, "treatCount": treatCount});
      }
    });
  }

  Future<void> rewindDogProfile(String currentUser, Profile swipedDog) async {
    final dogReference = _firestore.collection("dogs").document(swipedDog.id);
    _firestore.runTransaction((Transaction tx) async {
      final dog = await tx.get(dogReference);
      if (dog.exists) {
        final dogInfo = dog.data;
        final List<String> treats = List.from(dogInfo["treats"]);
        final List<String> likes = List.from(dogInfo["likes"]);

        if (treats.contains(currentUser)) {
          treats.remove(currentUser);
        }
        if (likes.contains(currentUser)) {
          likes.remove(currentUser);
        }

        return await tx.update(dogReference, {
          "treats": treats,
          "likes": likes,
        });
      }
    });
  }

  Future<List<Profile>> fetchDogProfiles(String currentUser) async {
    final String letters =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    final List<String> idLetters = letters.split("");

    List<String> autoID = new List();

    List<Profile> profiles = new List();

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    String breedFilter = preferences.getString("breedFilter");
    double minAgeFilter = preferences.getDouble("minAgeValue") != null
        ? preferences.getDouble("minAgeValue")
        : 0.0;
    double maxAgeFilter = preferences.getDouble("maxAgeValue") != null
        ? preferences.getDouble("maxAgeValue")
        : 30.0;

    final DateTime minDate =
        DateTime.now().subtract(Duration(days: minAgeFilter.ceil() * 365));
    final DateTime maxDate =
        DateTime.now().subtract(Duration(days: maxAgeFilter.ceil() * 365));

    for (int i = 0; i < 20; i++) {
      final int random = Random().nextInt(62);

      autoID.add(idLetters[random]);

      if (autoID.length == 20) {
        try {

          final dogDocuments1 = breedFilter != null ? await _firestore
          .collection("dogs")
          .where("breed", isEqualTo: breedFilter)
          .getDocuments() : await _firestore
          .collection("dogs")
          .getDocuments();

          final dogDocuments2 = new List<DocumentSnapshot>.from(dogDocuments1.documents.toSet().toList());

          final dogDocuments = new List<DocumentSnapshot>();

          final List<int> usedIndexes = new List<int>();

          for (i = 0; i < 25; i++) {
            final int dogLength = dogDocuments2.length;
            final int randomIndex = Random().nextInt(dogLength);

            usedIndexes.add(randomIndex);

            if (usedIndexes.contains(randomIndex)) {
              dogDocuments.add(dogDocuments2[randomIndex]);
            }          
          }

          // final dogDocuments1 = breedFilter != null
          //     ? await _firestore
          //         .collection("dogs")
          //         .where("id", isLessThanOrEqualTo: autoID.join())
          //         .where("breed", isEqualTo: breedFilter)
          //         // .where("dateOfBirth", isLessThanOrEqualTo: minDate)
          //         // .where("dateOfBirth", isGreaterThan: maxDate)
          //         .limit(25)
          //         .getDocuments()
          //     : await _firestore
          //         .collection("dogs")
          //         .where("id", isLessThanOrEqualTo: autoID.join())
          //         // .where("dateOfBirth", isLessThanOrEqualTo: minDate)
          //         // .where("dateOfBirth", isGreaterThan: maxDate)
          //         .limit(25)
          //         .getDocuments();

          // final dogDocuments2 = breedFilter != null
          //     ? await _firestore
          //         .collection("dogs")
          //         .where("id", isGreaterThan: autoID.join())
          //         .where("breed", isEqualTo: breedFilter)
          //         // .where("dateOfBirth", isLessThanOrEqualTo: minDate)
          //         // .where("dateOfBirth", isGreaterThan: maxDate)
          //         // .limit(25)
          //         .getDocuments()
          //     : await _firestore
          //         .collection("dogs")
          //         .where("id", isGreaterThan: autoID.join())
          //         // .where("dateOfBirth", isLessThanOrEqualTo: minDate)
          //         // .where("dateOfBirth", isGreaterThan: maxDate)
          //         // .limit(25)
          //         .getDocuments();

          // final dogDocuments = new List<DocumentSnapshot>.from(dogDocuments1.documents.toSet().toList() +
          //     dogDocuments2.documents.toSet().toList());

          final ageFilteredDogDocuments = new List<DocumentSnapshot>.from(dogDocuments.where((profile) => profile.data["dateOfBirth"].toDate().isAfter(maxDate) &&  profile.data["dateOfBirth"].toDate().isBefore(minDate) && profile.data["id"] != currentUser).toList());

          final filteredDogDocuments = new List<DocumentSnapshot>.from(ageFilteredDogDocuments.where((profile) => !profile.data["likes"].contains(currentUser) && !profile.data["treats"].contains(currentUser) && profile.data["owner"] != currentUser).toList());

          if (filteredDogDocuments.isNotEmpty) {
            for (DocumentSnapshot dogDocument in filteredDogDocuments) {
              final Map<String, dynamic> dogInfo = dogDocument.data;

              Profile dogProfile = Profile(
                name: dogInfo["name"],
                id: dogInfo["id"],
                dateOfBirth: dogInfo["dateOfBirth"].toDate(),
                breed: dogInfo["breed"],
                bio: dogInfo["bio"],
                gender: dogInfo["gender"],
                hobby: dogInfo["hobby"],
                owner: dogInfo["owner"],
                photos: dogInfo["photos"],
                treats: dogInfo["treats"],
                likeCount: dogInfo["likeCount"],
                treatCount: dogInfo["treatCount"],
              );

              profiles.add(dogProfile);

              if (profiles.length == filteredDogDocuments.length) {
                return profiles;
              }
            }
          } else {
            return List<Profile>();
          }
        } catch (error) {
          print(error);
          return null;
        }
      }
    }
  }

  Future<List<Profile>> fetchLeaderboardDogs(String breedFilter) async {
    
    List<Profile> profiles = new List<Profile>();

    print("BREED $breedFilter");

    try {
      final dogDocuments = breedFilter != null ? await _firestore.collection("dogs").where("breed", isEqualTo: breedFilter).orderBy("treatCount", descending: true).limit(25).getDocuments() : await _firestore.collection("dogs").orderBy("treatCount", descending: true).limit(25).getDocuments();
      if (dogDocuments.documents.isNotEmpty) {
        for (DocumentSnapshot dogDocument in dogDocuments.documents) {
          Map<String, dynamic> dogInfo = dogDocument.data;

          Profile dogProfile = Profile(
                name: dogInfo["name"],
                id: dogInfo["id"],
                dateOfBirth: dogInfo["dateOfBirth"].toDate(),
                breed: dogInfo["breed"],
                bio: dogInfo["bio"],
                gender: dogInfo["gender"],
                hobby: dogInfo["hobby"],
                owner: dogInfo["owner"],
                photos: dogInfo["photos"],
                treats: dogInfo["treats"],
                likeCount: dogInfo["likeCount"],
                treatCount: dogInfo["treatCount"],
              );
          
          profiles.add(dogProfile);

          if (profiles.length == dogDocuments.documents.length) {
            return profiles;
          }
        }
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  void deleteDogProfile(Profile dog) async {
    try {
      final dogRef = _firestore.collection("dogs").document(dog.id);
      return await dogRef.delete();
    } catch (error) {
      print(error);
      return null;
    }
  }
}
