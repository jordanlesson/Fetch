import 'package:fetch/pages/add_dog_info_page.dart';
import 'package:fetch/pages/dog_breed_page.dart';
import 'package:fetch/pages/email_settings_page.dart';
import 'package:fetch/pages/profile_page.dart';
import 'package:fetch/pages/start_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fetch/models/profile.dart';
import '../transitions.dart';
import 'accounts_page.dart';
import 'home_page.dart';
import 'master_page.dart';

class SettingsPage extends StatefulWidget {
  final FirebaseUser user;
  final Profile dog;

  SettingsPage({@required this.user, @required this.dog});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  RangeValues _ageRange;
  String _breedFilter;
  String _account;

  RangeValues _initialAgeRange;
  String _initialBreedFilter;

  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();

    _getUserPrefs();
  }

  Future<void> _getUserPrefs() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    double minAgeValue = preferences.getDouble("minAgeValue") != null
        ? preferences.getDouble("minAgeValue")
        : 0.0;
    double maxAgeValue = preferences.getDouble("maxAgeValue") != null
        ? preferences.getDouble("maxAgeValue")
        : 30.0;

    

    setState(() {
      _account = widget.dog != null ? widget.dog.id : null;
      _ageRange = RangeValues(minAgeValue, maxAgeValue);
      _breedFilter = preferences.get("breedFilter");

      _initialAgeRange = _ageRange;
      _initialBreedFilter = _breedFilter;
    });
  }

  Future<void> _updateUserInfo() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("account", _account);
    preferences.setString("breedFilter", _breedFilter);
    preferences.setDouble("minAgeValue", _ageRange.start);
    preferences.setDouble("maxAgeValue", _ageRange.end);
  }

  void _editEmail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => new EmailSettingsPage(),
      ),
    );
  }

  void _switchAccounts() {
    Navigator.of(context)
        .push(
          new MaterialPageRoute(
            builder: (BuildContext context) => new AccountsPage(
              user: widget.user,
            ),
          ),
        )
        .then(_onAccountSelected);
  }

  void _onAccountSelected(dynamic account) {
    if (account == "add account") {
      Navigator.of(context).push(
        SlideUpRoute(
          page: new AddDogInfoPage(
            user: widget.user,
          ),
        ),
      );
    } else if (account != null) {
      _account = account.id;

      _updateUserInfo();

      Navigator.of(context)
          .pushAndRemoveUntil(
        SlideUpRoute(
          page: new WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: new HomePage(
              onboarding: false,
              user: widget.user,
            ),
          ),
        ),
        (route) => route.isFirst,
      );
      Navigator.of(context)
          .push(
        SlideLeftRoute(
          page: new ProfilePage(
              user: widget.user,
              dog: null,
            ),
          
        ),
      );

    }
  }

  void _editDogBreed() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (BuildContext context) => new DogBreedPage(),
      ),
    )
        .then((breed) {
      if (breed != null) {
        setState(() {
          _breedFilter = breed;
        });
      }
    });
  }

  void _clearDogBreed() {
    setState(() {
      _breedFilter = null;
    });
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        "Settings",
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Proxima Nova",
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        TextActionButton(
          text: "Done",
          color: Color.fromRGBO(0, 122, 255, 1.0),
          onPressed: () {
            _updateUserInfo();
            Navigator.of(context).pop(
              _initialBreedFilter != _breedFilter || _initialAgeRange != _ageRange ? true : false
            );
          },
        ),
      ],
      bottom: PreferredSize(
        child: new Container(
          color: Colors.black12,
          height: 1.0,
        ),
        preferredSize: Size.fromHeight(1.0),
      ),
      elevation: 0.0,
    );
  }

  Widget _buildAccountSettings() {
    return new Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: new Text(
            "ACCOUNT SETTINGS",
            style: TextStyle(
              color: Color.fromRGBO(80, 80, 80, 1.0),
              fontSize: 14.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        new Container(
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
          child: new Column(
            children: <Widget>[
              new GestureDetector(
                child: new Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          "Account",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontFamily: "Proxima Nova",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      new Row(
                        children: <Widget>[
                          widget.dog != null
                              ? new Container(
                                  height: 25.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        widget.dog.photos.first,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : new Container(),
                          new Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            child: new Text(
                              widget.dog != null
                                  ? "${widget.dog.name}, ${new Profile().convertDate(widget.dog.dateOfBirth)}"
                                  : widget.user.email,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17.0,
                                fontFamily: "Proxima Nova",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 17.0,
                      ),
                    ],
                  ),
                ),
                onTap: _switchAccounts,
              ),
              // new Padding(
              //   padding: EdgeInsets.only(left: 16.0),
              //   child: new Divider(
              //     color: Colors.black12,
              //     height: 1.0,
              //   ),
              // ),
              // new GestureDetector(
              //     child: new Container(
              //       height: 50.0,
              //       alignment: Alignment.center,
              //       padding: EdgeInsets.symmetric(horizontal: 16.0),
              //       color: Colors.white,
              //       child: new Row(
              //         children: <Widget>[
              //           new Expanded(
              //             child: new Text(
              //               "Email",
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 17.0,
              //                 fontFamily: "Proxima Nova",
              //                 fontWeight: FontWeight.w400,
              //               ),
              //             ),
              //           ),
              //           new Padding(
              //             padding: EdgeInsets.only(right: 3.0),
              //             child: new Text(
              //               "jordantreylesson@gmail.com",
              //               style: TextStyle(
              //                 color: Theme.of(context).primaryColor,
              //                 fontSize: 17.0,
              //                 fontFamily: "Proxima Nova",
              //                 fontWeight: FontWeight.w400,
              //               ),
              //             ),
              //           ),
              //           new Icon(
              //             Icons.arrow_forward_ios,
              //             color: Colors.black26,
              //             size: 17.0,
              //           ),
              //         ],
              //       ),
              //     ),
              //     onTap: () => _editEmail()),
              // new Padding(
              //   padding: EdgeInsets.only(left: 16.0),
              //   child: new Divider(
              //     color: Colors.black12,
              //     height: 1.0,
              //   ),
              // ),
              // new Container(
              //   height: 50.0,
              //   alignment: Alignment.center,
              //   padding: EdgeInsets.symmetric(horizontal: 16.0),
              //   color: Colors.white,
              //   child: new Row(
              //     children: <Widget>[
              //       new Expanded(
              //         child: new Text(
              //           "Phone Number",
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 17.0,
              //             fontFamily: "Proxima Nova",
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //       ),
              //       new Padding(
              //         padding: EdgeInsets.only(right: 3.0),
              //         child: new Text(
              //           "(248) 882-4142",
              //           style: TextStyle(
              //             color: Colors.black54,
              //             fontSize: 17.0,
              //             fontFamily: "Proxima Nova",
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //       ),
              //       new Icon(
              //         Icons.arrow_forward_ios,
              //         color: Colors.black26,
              //         size: 17.0,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSettings() {
    return new Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: new Text(
            "FILTER",
            style: TextStyle(
              color: Color.fromRGBO(80, 80, 80, 1.0),
              fontSize: 14.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        new Container(
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
          child: new Column(
            children: <Widget>[
              new GestureDetector(
                  child: new Container(
                    height: 50.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    color: Colors.white,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            "Breed",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontFamily: "Proxima Nova",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(right: 3.0),
                          child: new Text(
                            _breedFilter != null ? _breedFilter : "All",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 17.0,
                              fontFamily: "Proxima Nova",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        _breedFilter != null
                            ? new GestureDetector(
                                child: new Icon(Icons.clear,
                                    color: Theme.of(context).primaryColor,
                                    size: 17.0),
                                onTap: _clearDogBreed,
                              )
                            : new Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black26,
                                size: 17.0,
                              ),
                      ],
                    ),
                  ),
                  onTap: () => _editDogBreed()),
              new Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: new Divider(
                  color: Colors.black12,
                  height: 1.0,
                ),
              ),
              new Container(
                height: 90.0,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            "Age",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontFamily: "Proxima Nova",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        new Text(
                          _ageRange != null
                              ? "${_ageRange.start.round().toString()}-${_ageRange.end.round().toString()} Years Old"
                              : "",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 17.0,
                            fontFamily: "Proxima Nova",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    new Expanded(
                      child: new Container(
                        alignment: Alignment.center,
                        child: new RangeSlider(
                          activeColor: Theme.of(context).primaryColor,
                          inactiveColor: Colors.black12,
                          values: _ageRange != null
                              ? _ageRange
                              : RangeValues(0.0, 30.0),
                          min: 0,
                          max: 30,
                          onChanged: (ageRange) {
                            setState(() {
                              _ageRange = ageRange;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegalSettings() {
    return new Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: new Text(
            "LEGAL",
            style: TextStyle(
              color: Color.fromRGBO(80, 80, 80, 1.0),
              fontSize: 14.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        new Container(
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
          child: new Column(
            children: <Widget>[
              new GestureDetector(
                child: new Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontFamily: "Proxima Nova",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      new Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 17.0,
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  const url =
                      'https://app.termly.io/document/privacy-policy/d25d7f6f-c09b-4122-9634-844b21e343df';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              new Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: new Divider(
                  color: Colors.black12,
                  height: 1.0,
                ),
              ),
              new GestureDetector(
                  child: new Container(
                    height: 50.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    color: Colors.white,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            "Terms of Service",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontFamily: "Proxima Nova",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        new Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black26,
                          size: 17.0,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    const url =
                        'https://app.termly.io/document/terms-of-use-for-website/759dbddd-085e-44c7-8c32-45afa2b26a9c';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVersionLabel() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Icon(
          IconData(0xe900, fontFamily: "fetch"),
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        new Text(
          "Version 2.1.4",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLogOutButton() {
    return new GestureDetector(
      child: new Container(
        height: 50.0,
        alignment: Alignment.center,
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
        child: new Text(
          "Logout",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 17.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onTap: _onLogOutPressed,
    );
  }

  Future<void> _onLogOutPressed() async {
    Navigator.of(context).pushAndRemoveUntil(
      SlideUpRoute(
        page: new StartPage(),
      ),
      (route) => false,
    );

    return await _userRepository.signOut();
  }

  Widget _buildDeleteAccountButton() {
    return new GestureDetector(
      child: new Container(
        height: 50.0,
        alignment: Alignment.center,
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
        child: new Text(
          "Delete Account",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onTap: _showDeleteAccountOptions,
    );
  }

  void _showDeleteAccountOptions() async {
    return await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: new Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: new Text(
              "Why do you want to delete your account?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Gotham Rounded",
                fontWeight: FontWeight.w300,
                letterSpacing: 0.2,
                wordSpacing: 0.1,
              ),
            ),
          ),
          content: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new CupertinoAlertDialogItem(
                  text: "Dissatisfied with Service",
                  icon: Icons.sentiment_dissatisfied,
                  onPressed: () {
                    Navigator.of(context).pop(0);
                  },
                ),
                new CupertinoAlertDialogItem(
                  text: "Experienced bugs",
                  icon: Icons.bug_report,
                  onPressed: () {
                    Navigator.of(context).pop(1);
                  },
                ),
                new CupertinoAlertDialogItem(
                  text: "Like cats more",
                  icon: Icons.thumb_down,
                  onPressed: () {
                    Navigator.of(context).pop(2);
                  },
                ),
                new CupertinoAlertDialogItem(
                  text: "Other",
                  icon: Icons.device_unknown,
                  onPressed: () {
                    Navigator.of(context).pop(3);
                  },
                ),
                new GestureDetector(
                  child: new Container(
                    height: 50.0,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: new Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(4);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((index) {
      if (index != 4) {
        _onDeleteOptionSelected();
      }
    });
  }

  void _onDeleteOptionSelected() async {
    return await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: new Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: new Text(
              "Are you sure you want to delete your account?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                wordSpacing: 0.1,
                height: 1.25,
              ),
            ),
          ),
          content: new Text(
            "Your account and all of your dog's profiles will be deleted and thus unrecoverable",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w500,
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
    ).then((delete) async {
      if (delete != null) {
        try {
          await _onLogOutPressed();

          await _userRepository.deleteAccount(widget.user.uid);
        } catch (error) {
          print(error);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: _buildAppBar(),
      body: new ListView.separated(
        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            // case 0:
            //   return _buildAccountSettings();
            //   break;
            case 0:
              return _buildAccountSettings();
              break;
            case 1:
              return _buildFilterSettings();
              break;
            case 2:
              return _buildLegalSettings();
              break;
            case 3:
              return new Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: _buildLogOutButton());
              break;
            case 4:
              return _buildVersionLabel();
              break;
            case 5:
              return _buildDeleteAccountButton();
              break;
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.transparent,
            height: 16.0,
          );
        },
        itemCount: 6,
      ),
    );
  }
}

class CupertinoAlertDialogItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  CupertinoAlertDialogItem({this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        height: 50.0,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.transparent,
          // border: Border(
          //   top: BorderSide(
          //     width: 1.0,
          //     color: Colors.black12,
          //   ),
          // ),
        ),
        child: icon != null
            ? new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(right: 3.0),
                    child: new Icon(
                      icon,
                      color: Colors.black87,
                    ),
                  ),
                  new Text(
                    text,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      fontFamily: "Gotham Rounded",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            : new Text(
                text,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
      onTap: onPressed,
    );
  }
}
