import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotificationRepository {
  final Firestore _firestore;
  final FirebaseMessaging _firebaseMessaging;

  NotificationRepository({Firestore firestore, FirebaseMessaging firebaseMessaging})
      : _firestore = firestore ?? Firestore.instance,
        _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging();

  void initializeNotifications(BuildContext context, String userID) async {
    if (Platform.isIOS) {
      StreamSubscription iosSubscription;

      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) async {
        String userToken = await _firebaseMessaging.getToken();

        if (userToken != null) {
          DocumentReference tokenRef = _firestore
              .collection("users")
              .document(userID)
              .collection("tokens")
              .document(userToken);

          await tokenRef.setData({
            "token": userToken,
            "createdAt": FieldValue.serverTimestamp(),
            "platform": Platform.operatingSystem,
          });
        }
      });

      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
        sound: true,
      ));
    } else {
      String userToken = await _firebaseMessaging.getToken();

      if (userToken != null) {
        DocumentReference tokenRef = _firestore
            .collection("users")
            .document(userID)
            .collection("tokens")
            .document(userToken);

        await tokenRef.setData({
          "token": userToken,
          "createdAt": FieldValue.serverTimestamp(),
          "platform": Platform.operatingSystem,
        });
      }
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final notificationSnackBar = new SnackBar(
          content: message["notification"]["title"],
          action: SnackBarAction(
            label: "View",
            onPressed: () => null,
          ),
        );

        Scaffold.of(context).showSnackBar(notificationSnackBar);
      },
      onResume: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
    );
  }
}
