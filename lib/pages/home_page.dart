import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch/blocs/profile_bloc/bloc.dart';
import 'package:fetch/pages/leaderboard_page.dart';
import 'package:fetch/pages/onboarding_page.dart';
import 'package:fetch/pages/settings_page.dart';
import 'package:fetch/resources/notification_repository.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:fetch/transitions.dart';
import 'package:fetch/ui/horizontal_divider.dart';
import 'package:fetch/ui/profile_header.dart';
import 'package:fetch/ui/side_menu_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fetch/ui/round_icon_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_page.dart';
import 'conversations_page.dart';
import 'package:fetch/matches.dart';
import 'package:fetch/cards.dart';
import 'package:fetch/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fetch/resources/dog_repository.dart';
import 'package:fetch/blocs/feed_bloc/bloc.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  final VoidCallback previousPage;
  final VoidCallback nextPage;
  final FirebaseUser user;
  final bool onboarding;

  HomePage(
      {Key key, this.onboarding, this.previousPage, this.nextPage, this.user})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final DogRepository _dogRepository = DogRepository();
  final UserRepository _userRepository = UserRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  FeedBloc _feedBloc;
  ProfileBloc _profileBloc;
  List<Profile> _dogProfiles;
  List<Profile> _swipedDogs;
  int swipeCount;
  Profile currentUser;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  StreamSubscription iosSubscription;

  final List<String> tips = [
    "Add multiple pictures of your dog to boost the amount of treats you receive",
    "Take pictures of your dog in unique and adventurous places to catch other user's eyes",
    "Be sure to create a bio where you can give a brief description of your dog",
    "Remember to add your dog's favorite hobby onto its profile",
  ];
  int tipIndex;

  @override
  void initState() {
    super.initState();

    _feedBloc = FeedBloc(
      dogRepository: _dogRepository,
    );

    _profileBloc = ProfileBloc(
      userRepository: _userRepository,
    );

    _profileBloc.dispatch(
      ProfileStarted(
        userID: widget.user.uid,
      ),
    );

    _fetchCurrentUser();

    _dogProfiles = new List<Profile>();
    _swipedDogs = new List<Profile>();

    swipeCount = 0;
    tipIndex = 0;

    if (widget.onboarding) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _showOnboarding());
    }
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _initializeNotifications());
  }

  void _initializeNotifications() {
    if (Platform.isIOS) {
      iosSubscription =
          FirebaseMessaging().onIosSettingsRegistered.listen((data) {
        _saveDeviceToken();
      });

      FirebaseMessaging().requestNotificationPermissions(
        IosNotificationSettings(
          sound: true,
          badge: true,
          alert: true,
        ),
      );

      FirebaseMessaging().configure(
        onMessage: (Map<String, dynamic> message) async {
          print(message);

          final notificationSnackBar = new SnackBar(
            content: message["notification"]["title"],
            action: SnackBarAction(
              label: "View",
              onPressed: () => null,
            ),
          );

          Scaffold.of(context).showSnackBar(notificationSnackBar);
        },
        onResume: (Map<String, dynamic> message) async {
          print(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print(message);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => new ConversationsPage(
                user: widget.user,
              ),
            ),
          );
        },
      );
    } else {
      _saveDeviceToken();
    }
  }

  void _saveDeviceToken() async {
    String userToken = await FirebaseMessaging().getToken();
    print("User Token: $userToken");

    if (userToken != null) {
      DocumentReference tokenRef = Firestore.instance
          .collection("users")
          .document(widget.user.uid)
          .collection("tokens")
          .document(userToken);

      await tokenRef.setData({
        "token": userToken,
        "createdAt": FieldValue.serverTimestamp(),
        "platform": Platform.operatingSystem,
      });
    }
  }

  void _showOnboarding() {
    Navigator.of(context).push(
      SlideUpRoute(
        page: OnboardingPage(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _feedBloc.dispose();

    super.dispose();
  }

  void _fetchCurrentUser() async {
    try {
      currentUser = await _userRepository.getDogProfile(widget.user.uid);

      setState(() {
        _feedBloc.dispatch(
          FeedStarted(
            currentUser: widget.user.uid,
          ),
        );
      });
    } catch (error) {
      print(error);
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return new SafeArea(
      top: true,
      bottom: false,
      child: new Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            new GestureDetector(
              child: new Icon(
                IconData(0xe900, fontFamily: "fetch"),
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).push(
                  SlideUpRoute(
                    page: new OnboardingPage(),
                  ),
                );
              },
            ),
            new Container(
              width: 45.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideMenu(ProfileState state) {
    return new Drawer(
      child: Container(
        color: Colors.white,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new ProfileHeader(
                dog: state.dogProfile, profileImage: state.profileImage),
            new Expanded(
              flex: 2,
              child: new ListView(
                padding: EdgeInsets.only(top: 0.0),
                children: <Widget>[
                  SideMenuButton(
                    text: "Profile",
                    icon: IconData(0xe900, fontFamily: "dog"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        SlideLeftRoute(
                          page: new ProfilePage(
                            user: widget.user,
                            dog: state.dogProfile != null
                                ? state.dogProfile
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                  SideMenuButton(
                    text: "Conversations",
                    icon: Icons.message,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        SlideLeftRoute(
                          page: new ConversationsPage(
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                  ),
                  SideMenuButton(
                    text: "Leaderboards",
                    icon: Icons.poll,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        SlideLeftRoute(
                          page: new LeaderboardPage(
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                  ),
                  // SideMenuButton(
                  //   text: "Store",
                  //   icon: Icons.local_grocery_store,
                  //   onPressed: null,
                  // ),
                  SideMenuButton(
                    text: "Settings",
                    icon: Icons.settings,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        SlideUpRoute(
                          page: new SettingsPage(
                            user: widget.user,
                            dog: currentUser,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return new SafeArea(
      top: false,
      bottom: true,
      child: new Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new AdmobBanner(
              adSize: AdmobBannerSize.BANNER,
              adUnitId: "ca-app-pub-7132470146221772/1339722046",
              listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                switch (event) {
                  case AdmobAdEvent.loaded:
                    print('Admob banner loaded!');
                    break;

                  case AdmobAdEvent.opened:
                    print('Admob banner opened!');
                    break;

                  case AdmobAdEvent.closed:
                    print('Admob banner closed!');
                    break;

                  case AdmobAdEvent.failedToLoad:
                    print(
                        'Admob banner failed to load. Error code: ${args['errorCode']}');
                    break;
                  case AdmobAdEvent.clicked:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.impression:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.leftApplication:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.completed:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.rewarded:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.started:
                    // TODO: Handle this case.
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onRewindComplete(List<Profile> dogs, List<Profile> swipedDogs) {
    _feedBloc.dispatch(
      FeedRewinded(
        dogs: dogs,
        swipedDogs: swipedDogs,
        currentUser: widget.user.uid,
      ),
    );
  }

  Widget _buildCard(FeedState state) {
    if (state.dogs.isNotEmpty && state.isSuccess) {
      return new Stack(
        children: <Widget>[
          new CardStack(
            dogRepository: _dogRepository,
            profiles: state.dogs,
            swipedDogs: state.swipedDogs,
            currentDog: currentUser,
            currentUser: widget.user.uid,
            onSlideOutComplete: _onSlideOutComplete,
            onRewindComplete: _onRewindComplete,
          ),
        ],
      );
    } else if (state.dogs.isEmpty && state.isSuccess) {
      tipIndex = tipIndex != 3 ? tipIndex + 1 : 0;

      return new Center(
        child: new Stack(
          alignment: Alignment.center,
          children: <Widget>[
            new Opacity(
              opacity: 0.25,
              child: new Container(
                margin: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    new BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/dog_photo_$tipIndex.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "No Dogs Available",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                new GestureDetector(
                  child: new Container(
                    height: 40.0,
                    width: 120.0,
                    margin: EdgeInsets.only(top: 10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 122, 255, 1.0),
                          Color.fromRGBO(0, 175, 230, 1.0),
                          Color.fromRGBO(0, 255, 230, 1.0),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: new Offset(0.0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: new Text(
                      "Reload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onTap: () {
                    _feedBloc.dispatch(
                      FeedStarted(currentUser: widget.user.uid),
                    );
                  },
                ),
                new Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  constraints: BoxConstraints(
                    maxWidth: 350.0,
                  ),
                  child: new Text(
                    "Tip: ${tips[tipIndex]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontFamily: "Proxima Nova",
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (state.isLoading) {
      return new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              height: 30.0,
              width: 30.0,
              margin: EdgeInsets.only(bottom: 5.0),
              child: new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
            new Text(
              "Fetching Dogs",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    } else if (state.isFailure) {
      return new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              height: 30.0,
              width: 30.0,
              margin: EdgeInsets.only(bottom: 5.0),
              child: new Icon(
                Icons.signal_wifi_off,
                color: Colors.black87,
              ),
            ),
            new Text(
              "Unable to Connect to the Internet",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
            new GestureDetector(
              child: new Container(
                height: 40.0,
                width: 120.0,
                margin: EdgeInsets.only(top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 122, 255, 1.0),
                      Color.fromRGBO(0, 175, 230, 1.0),
                      Color.fromRGBO(0, 255, 230, 1.0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: new Offset(0.0, 4.0),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: new Text(
                  "Reload",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onTap: () {
                _feedBloc.dispatch(
                  FeedStarted(currentUser: widget.user.uid),
                );
              },
            ),
          ],
        ),
      );
    }
    return new Container();
  }

  void _onSlideOutComplete(SlideDirection direction) {
    // DogMatch currentMatch = widget.matchEngine.currentMatch;

    switch (direction) {
      case SlideDirection.left:
        _feedBloc.dispatch(
          ProfileDisliked(
            dogs: _dogProfiles,
            swipedDogs: _swipedDogs,
          ),
        );
        break;
      case SlideDirection.right:
        _feedBloc.dispatch(
          ProfileLiked(
            dogs: _dogProfiles,
            currentUser: widget.user.uid,
            swipedDogs: _swipedDogs,
          ),
        );
        break;
      case SlideDirection.up:
        _feedBloc.dispatch(
          ProfileTreated(
            dogs: _dogProfiles,
            currentUser: widget.user.uid,
            swipedDogs: _swipedDogs,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new BlocProvider(
      bloc: _profileBloc,
      child: new BlocBuilder(
        bloc: _profileBloc,
          builder: (BuildContext context, ProfileState profileState) {
        return new Scaffold(
          key: _scaffoldKey,
          drawer: profileState.isEmpty ? null : _buildSideMenu(profileState),
          body: Column(
            children: <Widget>[
              new Expanded(
                child: new BlocProvider(
                  bloc: _feedBloc,
                  child: new BlocListener(
                    bloc: _feedBloc,
                    listener: (BuildContext context, FeedState state) async {
                      _dogProfiles = List.from(state.dogs);
                      _swipedDogs = List.from(state.swipedDogs);
                      if (state.dogs.length == 5) {
                        _feedBloc.dispatch(
                          FeedRanLow(
                            currentUser: widget.user.uid,
                            dogs: state.dogs,
                            swipedDogs: state.swipedDogs,
                          ),
                        );
                      }
                      if (state.swipedDogs.length % 15 == 0 &&
                          state.swipedDogs.isNotEmpty) {
                        AdmobInterstitial feedInterstitialAd;
                        feedInterstitialAd = AdmobInterstitial(
                          adUnitId: "ca-app-pub-7132470146221772/4532985304",
                          listener:
                              (AdmobAdEvent event, Map<String, dynamic> args) {
                            if (event == AdmobAdEvent.loaded) {
                              feedInterstitialAd.show();
                            }
                            if (event == AdmobAdEvent.closed) {
                              feedInterstitialAd.dispose();
                            }
                            if (event == AdmobAdEvent.failedToLoad) {
                              // Start hoping they didn't just ban your account :)
                              print("Error code: ${args['errorCode']}");
                            }
                          },
                        );
                        feedInterstitialAd.load();
                      }
                    },
                    child: new BlocBuilder(
                      bloc: _feedBloc,
                      builder: (BuildContext context, FeedState feedState) {
                        return new Scaffold(
                          //key: _scaffoldKey,
                          backgroundColor: Colors.white,
                          //drawer: _buildSideMenu(profileState),
                          body: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _buildAppBar(context),
                              new Expanded(
                                child: _buildCard(feedState),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        );
      }),
    );
  }
}
