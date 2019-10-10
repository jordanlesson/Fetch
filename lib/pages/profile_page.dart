import 'package:fetch/pages/add_dog_info_page.dart';
import 'package:fetch/pages/settings_page.dart';
import 'package:fetch/ui/login_button.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/round_profile_button.dart';
import 'package:fetch/ui/profile_view.dart';
import 'package:fetch/models/profile.dart';
import 'package:fetch/transitions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_page.dart';
import 'profile_info_page.dart';
import 'profile_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:fetch/blocs/profile_bloc/bloc.dart';
import 'settings_page.dart';
import 'package:fetch/utils/formatters.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseUser user;
  final Profile dog;

  ProfilePage({Key key, @required this.user, @required this.dog})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final UserRepository _userRepository = UserRepository();
  ProfileBloc _profileBloc;

  int sortIndex;

  Profile dog;

  void initState() {
    super.initState();
    sortIndex = 0;

    _profileBloc = new ProfileBloc(userRepository: _userRepository);

    if (widget.dog == null) {
      _profileBloc.dispatch(
        ProfileStarted(userID: widget.user.uid),
      );
    } else {
      dog = widget.dog;
    }
  }

  @override
  void dispose() {
    _profileBloc.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Icon(
        IconData(0xe900, fontFamily: "dog"),
        color: Colors.black,
      ),
      centerTitle: true,
      leading: new BackButton(
        color: Colors.black,
      ),
      elevation: 0.0,
    );
  }

  Widget _buildProfileImage(Profile dogProfile, ProfileState state) {
    return new GestureDetector(
      child: new Container(
        height: 175.5,
        width: 175.5,
        child: new Stack(
          alignment: Alignment.center,
          children: <Widget>[
            new Container(
              height: 150.0,
              width: 150.0,
              decoration: dogProfile != null
                  ? BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          dogProfile.photos.first,
                        ),
                        fit: BoxFit.cover,
                      ),
                    )
                  : BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
              child: dogProfile == null
                  ? new Icon(
                      Icons.person,
                      color: Colors.black38,
                      size: 75.0,
                    )
                  : new Container(),
            ),
            dogProfile != null
                ? new Align(
                    alignment: Alignment.bottomRight,
                    child: new Container(
                      height: 75.0,
                      width: 75.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: new Container(
                        height: 55.0,
                        width: 55.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 0.5,
                            color: Colors.grey,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: new Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : new Container(),
          ],
        ),
      ),
      onTap: dogProfile != null
          ? () {
              Navigator.of(context)
                  .push(
                SlideUpRoute(
                  page: ProfileInfoPage(
                    profile: Profile(
                      name: dogProfile.name,
                      id: dogProfile.id,
                      dateOfBirth: dogProfile.dateOfBirth,
                      breed: dogProfile.breed,
                      bio: dogProfile.bio,
                      gender: dogProfile.gender,
                      hobby: dogProfile.hobby,
                      owner: dogProfile.owner,
                      photos: dogProfile.photos,
                      photoPaths: dogProfile.photoPaths,
                      treats: dogProfile.treats,
                      likes: dogProfile.likes,
                      likeCount: dogProfile.likeCount,
                      treatCount: dogProfile.treatCount,
                    ),
                    profileImage: state.profileImage,
                    currentUser: widget.user.uid,
                  ),
                ),
              )
                  .then((_) {
                _updateDogProfile(dogProfile);
              });
            }
          : null,
    );
  }

  void _updateDogProfile(Profile dogProfile) {
    _profileBloc.dispatch(
      ProfileReloadPressed(userID: dogProfile.owner),
    );
  }

  Widget _buildProfileTitle(Profile dogProfile) {
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new Text(
        dogProfile != null
            ? "${dogProfile.name}, ${Profile().convertDate(dogProfile.dateOfBirth)}"
            : "${widget.user.email}",
        style: TextStyle(
          fontSize: dogProfile != null ? 25.0 : 18.0,
          fontFamily: "Gotham Rounded",
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProfileSubtitle(Profile dogProfile) {
    return new Container(
      margin: EdgeInsets.only(top: 5.0),
      child: new Text(
        dogProfile != null ? dogProfile.breed : "Dog Lover",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProfileStatistics(Profile dogProfile) {
    return new Container(
      height: 125.0,
      padding: EdgeInsets.all(1.0),
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
      constraints: BoxConstraints(
        maxWidth: 350.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 122, 255, 1.0),
            Color.fromRGBO(0, 175, 230, 1.0),
            Color.fromRGBO(0, 255, 230, 1.0),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.0),
                  topRight: Radius.circular(14.0),
                ),
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  dogProfile != null
                      ? ProfileStatistic.likes(
                          number: dogProfile.likeCount,
                        )
                      : new Container(),
                  dogProfile != null
                      ? ProfileStatistic.treats(
                          number: dogProfile.treatCount,
                        )
                      : new Container(),
                ],
              ),
            ),
          ),
          new Container(
            height: 41.67,
            alignment: Alignment.center,
            child: new Text(
              "Profile Stats",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTabBar() {
    return SliverToBoxAdapter(
      child: new Container(
        height: 30.0,
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
        color: Color.fromRGBO(245, 245, 245, 1.0),
        child: new GestureDetector(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(right: 5.0),
                child: new Icon(
                  sortIndex == 0
                      ? Icons.thumb_up
                      : IconData(0xe900, fontFamily: "treat"),
                  color: Theme.of(context).primaryColor,
                  size: 18.0,
                ),
              ),
              new Text(
                sortIndex == 0 ? "LIKES" : "TREATS",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                ),
              ),
              new Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
                size: 18.0,
              )
            ],
          ),
          onTap: _onSort,
        ),
      ),
    );
  }

  Future<Null> _onSort() async {

    SystemChrome.setEnabledSystemUIOverlays([]);

    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          bottom: true,
          child: new Material(
            type: MaterialType.transparency,
            child: new Container(
              height: 200.0,
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Container(
                    height: 35.0,
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: Colors.black12,
                        ),
                      ),
                    ),
                    child: new Text(
                      "SORT BY",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12.0,
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new ActionSheetButton(
                      text: "Likes",
                      icon: Icons.thumb_up,
                      enabled: sortIndex == 0 ? true : false,
                      onPressed: () {
                        Navigator.of(context).pop(0);
                      },
                    ),
                  ),
                  new Expanded(
                    child: new ActionSheetButton(
                      text: "Treats",
                      icon: IconData(0xe900, fontFamily: "treat"),
                      enabled: sortIndex == 1 ? true : false,
                      onPressed: () {
                        Navigator.of(context).pop(1);
                      },
                    ),
                  ),
                  new GestureDetector(
                    child: new Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: new Text(
                        "CANCEL",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontFamily: "Proxima Nova",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((index) {

      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
      
      if (index != null) {
        setState(() {
          sortIndex = index;
        });
      }
    });
  }

  Widget _buildProfileList(Profile dogProfile) {
    return new StreamBuilder(
      stream: sortIndex == 0
          ? Firestore.instance
              .collection("dogs")
              .where("likes", arrayContains: widget.user.uid)
              .orderBy("treatCount", descending: true)
              .snapshots()
          : Firestore.instance
              .collection("dogs")
              .where("treats", arrayContains: widget.user.uid)
              .orderBy("treatCount", descending: true)
              .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {

          List<DocumentSnapshot> dogs = List.from(snapshot.data.documents.where((dog) => dog.exists));
          
          return new SliverPadding(
            padding: EdgeInsets.only(bottom: 16.0),
            sliver: new SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {

                  return new Container(
                    height: 450.0,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 10.0),
                    child: new Column(
                      children: <Widget>[
                        new Expanded(
                          child: new Stack(
                            children: <Widget>[
                              new ProfileView(
                                profile: Profile(
                                  name: dogs[index].data["name"],
                                  id: dogs[index].data["id"],
                                  dateOfBirth: dogs[index].data["dateOfBirth"]
                                      .toDate(),
                                  breed: dogs[index].data["breed"],
                                  bio: dogs[index].data["bio"],
                                  gender: dogs[index].data["gender"],
                                  hobby: dogs[index].data["hobby"],
                                  owner: dogs[index].data["owner"],
                                  photos: dogs[index].data["photos"],
                                  photoPaths: dogs[index].data["photoPaths"],
                                  treats: dogs[index].data["treats"],
                                  likes: dogs[index].data["likes"],
                                  likeCount: dogs[index].data["likeCount"],
                                  treatCount: dogs[index].data["treatCount"],
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                width: 1.0,
                                color: Colors.black12,
                              ),
                              bottom: BorderSide(
                                width: 1.0,
                                color: Colors.black12,
                              ),
                            ),
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new IconButton(
                                icon: Icon(
                                  Icons.info_outline,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                    SlideUpRoute(
                                      page: ProfileDetailsPage(
                                        currentUser: widget.user.uid,
                                        currentDog: dogProfile,
                                        profile: Profile(
                                          name: dogs[index].data
                                              ["name"],
                                          id: dogs[index].data["id"],
                                          dateOfBirth: dogs[index]
                                              .data["dateOfBirth"]
                                              .toDate(),
                                          breed: dogs[index]
                                              .data["breed"],
                                          bio: dogs[index]
                                              .data["bio"],
                                          gender: dogs[index]
                                              .data["gender"],
                                          hobby: dogs[index]
                                              .data["hobby"],
                                          owner: dogs[index]
                                              .data["owner"],
                                          photos: dogs[index]
                                              .data["photos"],
                                          photoPaths: dogs[index]
                                              .data["photoPaths"],
                                          treats: dogs[index]
                                              .data["treats"],
                                          likes: dogs[index]
                                              .data["likes"],
                                          likeCount: dogs[index]
                                              .data["likeCount"],
                                          treatCount: dogs[index]
                                              .data["treatCount"],
                                        ),
                                        visiblePhotoIndex: 0,
                                        isDecidable: true,
                                      ),
                                    ),
                                  )
                                      .then((delete) {
                                    if (delete != null) {
                                      _onDeleteProfile(dogs[index].documentID);
                                    }
                                  });
                                },
                              ),
                              new Row(
                                children: <Widget>[
                                  new Container(
                                    margin:
                                        EdgeInsets.only(left: 16.0, right: 5.0),
                                    child: new Text(
                                      "${dogs[index].data["name"]}, ${Profile().convertDate(dogs[index].data["dateOfBirth"].toDate())}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Icon(
                                    IconData(0xe900, fontFamily: "gender_male"),
                                    color: Colors.blue,
                                    size: 20.0,
                                  )
                                ],
                              ),
                              new IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.black,
                                ),
                                onPressed: () => _showDeleteOptions(
                                    dogs[index].documentID),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: dogs.length,
              ),
            ),
          );
        } else {
          return new SliverToBoxAdapter(
            child: new Center(
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
            ),
          );
        }
      },
    );
  }

  void _showDeleteOptions(String userID) async {

    SystemChrome.setEnabledSystemUIOverlays([]);

    return await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: new Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: new Text(
              "Delete this dog off your feed?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                wordSpacing: 0.1,
                height: 1.2,
              ),
            ),
          ),
          actions: <Widget>[
            new GestureDetector(
              child: Material(
                type: MaterialType.transparency,
                child: new Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        width: 1.0,
                        color: Colors.black12,
                      ),
                      right: BorderSide(
                        width: 0.5,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  child: new Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      fontFamily: "Proxima Nova",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            new GestureDetector(
              child: new Material(
                type: MaterialType.transparency,
                child: new Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        width: 1.0,
                        color: Colors.black12,
                      ),
                      left: BorderSide(
                        width: 0.5,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  child: new Text(
                    "Delete",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontFamily: "Proxima Nova",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop("delete");
              },
            ),
          ],
        );
      },
    ).then(
      (delete) {
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
        if (delete != null) {
          _onDeleteProfile(userID);
        }
      },
    );
  }

  void _onDeleteProfile(String userID) {
    final dogRef = Firestore.instance.collection("dogs").document(userID);
    Firestore.instance.runTransaction(
      (Transaction tx) async {
        final dogSnapshot = await tx.get(dogRef);
        if (sortIndex == 0) {
          final likes = new List.from(dogSnapshot.data["likes"]);
          if (likes.contains(widget.user.uid)) {
            likes.remove(widget.user.uid);
            final likeCount = likes.length;
            await tx.update(dogRef, {"likes": likes, "likeCount": likeCount});
          }
        } else {
          final treats = new List.from(dogSnapshot.data["treats"]);
          if (treats.contains(widget.user.uid)) {
            treats.remove(widget.user.uid);
            final treatCount = treats.length;
            await tx
                .update(dogRef, {"treats": treats, "treatCount": treatCount});
          }
        }
      },
    );
  }

  Widget _buildProfileLoading() {
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
            "Fetching Profile",
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
  }

  Widget _buildProfileError() {
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
            "Unable To Load Profile",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddDog() {
    return new Expanded(
      child: new Center(
        child: new LoginButton(
          text: "Switch to a Dog Account",
          onPressed: () {
            Navigator.of(context).push(
              SlideUpRoute(
                page: AddDogInfoPage(
                  user: widget.user,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new BlocProvider(
      bloc: _profileBloc,
      child: new BlocListener(
        bloc: _profileBloc,
        listener: (BuildContext context, ProfileState state) {
          if (state.dogProfile != null) {
            dog = state.dogProfile;
          }
        },
        child: BlocBuilder(
          bloc: _profileBloc,
          builder: (BuildContext context, ProfileState state) {
            return new Scaffold(
              backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
              appBar: _buildAppBar(),
              body: dog != null || state.dogProfile != null || state.isEmpty
                  ? new CustomScrollView(
                      shrinkWrap: true,
                      slivers: <Widget>[
                        new SliverToBoxAdapter(
                          child: new Container(
                            height: 400.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _buildProfileImage(dog, state),
                                _buildProfileTitle(dog),
                                _buildProfileSubtitle(dog),
                                dog != null
                                    ? new Container()
                                    : _buildAddDog(),
                                dog != null
                                    ? _buildProfileStatistics(dog)
                                    : new Container(),
                              ],
                            ),
                          ),
                        ),
                        _buildProfileTabBar(),
                        _buildProfileList(dog),
                      ],
                    )
                  : _buildProfileLoading(),
            );
          },
        ),
      ),
    );
  }
}

class MediaBox extends StatelessWidget {
  final String photo;

  MediaBox({
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: new Image.network(
        photo,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ProfileStatistic extends StatelessWidget {
  final int number;
  final String statisticTitle;
  final IconData icon;

  ProfileStatistic.likes({this.number})
      : statisticTitle = "Likes",
        icon = Icons.thumb_up;

  ProfileStatistic.treats({this.number})
      : statisticTitle = "Treats",
        icon = IconData(0xe900, fontFamily: "treat");

  String textFormatter(int statistic) {
    if (statistic >= 1000000000) {
      return "${statistic.toString()[0]}B";
    } else if (statistic >= 100000000) {
      return "${statistic.toString()[0]}${statistic.toString()[1]}${statistic.toString()[2]}M";
    } else if (statistic >= 10000000) {
      return "${statistic.toString()[0]}${statistic.toString()[1]}M";
    } else if (statistic >= 1000000) {
      return "${statistic.toString()[0]}.${statistic.toString()[1]}M";
    } else if (statistic >= 100000) {
      return "${statistic.toString()[0]}${statistic.toString()[1]}.${statistic.toString()[2]}K";
    } else if (statistic >= 10000) {
      return "${statistic.toString()[0]}.${statistic.toString()[1]}K";
    } else if (statistic >= 5000) {
      return "${statistic.toString()[0]}K";
    }
    return statistic.toString();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 100.0,
      alignment: Alignment.center,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: new Text(
              textFormatter(number),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 30.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(right: 3.0),
                child: new Icon(
                  icon,
                  color: Colors.black87,
                  size: 16.0,
                ),
              ),
              new Text(
                statisticTitle,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionSheetButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  ActionSheetButton({this.text, this.icon, this.enabled, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        child: new Row(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(right: 5.0),
              child: new Icon(
                icon,
                color:
                    enabled ? Theme.of(context).primaryColor : Colors.black87,
                size: 18.0,
              ),
            ),
            new Text(
              text,
              style: TextStyle(
                  color:
                      enabled ? Theme.of(context).primaryColor : Colors.black87,
                  fontSize: 18.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
