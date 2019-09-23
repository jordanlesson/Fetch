// import 'dart:async';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'home_page.dart';
// import 'conversations_page.dart';
// import 'profile_page.dart';
// import 'package:fetch/cards.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class MasterPage extends StatefulWidget {

//   final FirebaseUser user;
//   final bool onboarding;
//   final int initialPage;
  
//   MasterPage({this.user, this.onboarding, @required this.initialPage});

//   @override
//   _MasterPageState createState() => _MasterPageState();
// }

// class _MasterPageState extends State<MasterPage> with AutomaticKeepAliveClientMixin {
//   PageController pageController;
//   int _pageIndex;
//   FirebaseUser user;

//   StreamSubscription iosSubscription;

//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController(
//       initialPage: widget.initialPage,
//       keepPage: true,    
//     );

//     user = widget.user;

//     _pageIndex = widget.initialPage;

//     SchedulerBinding.instance.addPostFrameCallback((_) => _initializeNotifications());
//   }

//   void _initializeNotifications() {
//     if (Platform.isIOS) {

//       iosSubscription = FirebaseMessaging().onIosSettingsRegistered.listen((data) {
//         _saveDeviceToken();
//       });

//       FirebaseMessaging().requestNotificationPermissions(
//         IosNotificationSettings(
//           sound: true,
//           badge: true,
//           alert: true,
//         ),
//       );

//       FirebaseMessaging().configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print(message);

//         final notificationSnackBar = new SnackBar(
//           content: message["notification"]["title"],
//           action: SnackBarAction(
//             label: "View",
//             onPressed: () => null,
//           ),
//         );

//         Scaffold.of(context).showSnackBar(notificationSnackBar);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print(message);
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print(message);
//         pageController.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
//       },
//     );

//     } else {
//       _saveDeviceToken();
//     }
//   }

//   void _saveDeviceToken() async {
//     String userToken = await FirebaseMessaging().getToken();
//     print("User Token: $userToken");

//         if (userToken != null) {
//           DocumentReference tokenRef = Firestore.instance
//               .collection("users")
//               .document(widget.user.uid)
//               .collection("tokens")
//               .document(userToken);

//           await tokenRef.setData({
//             "token": userToken,
//             "createdAt": FieldValue.serverTimestamp(),
//             "platform": Platform.operatingSystem,
//           });
//         }
//   }

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;

//   void _onPageChanged(int pageIndex) {
//     setState(() {
//       _pageIndex = pageIndex;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return new Scaffold(
//       backgroundColor: Colors.white,
//       // appBar: _buildAppBar(),
//       body: new PageView(
//         controller: pageController,
//         onPageChanged: _onPageChanged,
//         physics: _pageIndex != 1.0
//             ? ScrollPhysics(parent: ClampingScrollPhysics())
//             : ScrollPhysics(parent: NeverScrollableScrollPhysics()),
//         children: <Widget>[
//           new ProfilePage(
//             key: PageStorageKey<String>("Profile Page"),
//             user: widget.user,
//             nextPage: () {
//             pageController.nextPage(
//               curve: Curves.linear,
//               duration: Duration(milliseconds: 200),
//             );
//           },
//           ),
//           new HomePage(
//             key: PageStorageKey<String>("Home Page"),
//             user: widget.user,
//             onboarding: widget.onboarding,
//             previousPage: () {
//               pageController.previousPage(
//               curve: Curves.linear,
//               duration: Duration(milliseconds: 200),
//             );
//             },
//             nextPage: () {
//               pageController.nextPage(
//               curve: Curves.linear,
//               duration: Duration(milliseconds: 200),
//             );
//             },
//           ),
//           new ConversationsPage(
//             key: PageStorageKey<String>("Conversations Page"),
//             user: widget.user,
//             previousPage: () {
//               pageController.previousPage(
//               curve: Curves.linear,
//               duration: Duration(milliseconds: 200),
//             );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
