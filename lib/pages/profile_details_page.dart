import 'package:fetch/conversation.dart';
import 'package:fetch/pages/messages_page.dart';
import 'package:fetch/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fetch/models/profile.dart';
import 'package:fetch/matches.dart';
import 'package:fetch/ui/subtitle_label.dart';
import 'package:fetch/ui/round_icon_button.dart';
import 'package:fetch/ui/profile_view.dart';
import 'package:fetch/photos.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDetailsPage extends StatefulWidget {
  final Profile profile;
  final Profile currentDog;
  final String currentUser;
  final int visiblePhotoIndex;
  final isDecidable;

  ProfileDetailsPage({
    Key key,
    @required this.profile,
    @required this.currentDog,
    @required this.currentUser,
    this.visiblePhotoIndex,
    this.isDecidable = true,
  }) : super(key: key);

  @override
  _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  int visiblePhotoIndex;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    visiblePhotoIndex = widget.visiblePhotoIndex;
  }

  Widget _buildBottomBar() {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.transparent,
      child: new Hero(
        tag: "Bottom Bar",
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              width: 55.0,
              height: 55.0,
            ),
            new RoundIconButton.large(
              icon: Icons.thumb_down,
              iconColor: Colors.red,
              onPressed: () {
                //matchEngine.currentMatch.dislike();
              },
            ),
            new RoundIconButton.small(
              icon: Icons.favorite,
              iconColor: Colors.blue,
              onPressed: () {
                //matchEngine.currentMatch.superLike();
              },
            ),
            new RoundIconButton.large(
              icon: Icons.thumb_up,
              iconColor: Colors.green,
              onPressed: () {
                //matchEngine.currentMatch.like();
              },
            ),
            new Container(
              width: 55.0,
              height: 55.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final screenSize = MediaQuery.of(context).size;

    return new Hero(
      tag: widget.profile.id,
      child: new Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          new Container(
            height: screenSize.height * 0.7,
            child: new ProfilePhotoBrowser(
              photos: widget.profile.photos,
              visiblePhotoIndex: visiblePhotoIndex,
            ),
          ),
          new GestureDetector(
            child: new Container(
              height: 50.0,
              width: 50.0,
              margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 122, 255, 1.0),
                    Color.fromRGBO(0, 150, 255, 1.0),
                    Color.fromRGBO(0, 255, 200, 1.0),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 3.0),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: new Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new RichText(
                text: TextSpan(
                  children: [
                    new TextSpan(
                      text: widget.profile.name,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.80),
                          fontSize: 35.0,
                          fontFamily: "Proxima Nova",
                          fontWeight: FontWeight.w700,
                          ),
                    ),
                    new TextSpan(
                      text: " ",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: "Proxima Nova",
                      ),
                    ),
                    new TextSpan(
                      text: Profile().convertDate(widget.profile.dateOfBirth),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.80),
                        fontSize: 25.0,
                        fontFamily: "Proxima Nova",
                        //fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: EdgeInsets.all(5.0),
                child: new Icon(
                  widget.profile.gender == "male"
                      ? IconData(0xe900, fontFamily: "gender_male")
                      : IconData(0xe900, fontFamily: "gender_female"),
                  color: widget.profile.gender == "male"
                      ? Colors.blue
                      : Colors.pink,
                ),
              ),
              widget.isDecidable
                  ? new Expanded(
                      child: new Align(
                        alignment: Alignment.centerRight,
                        child: new GestureDetector(
                          child: new Container(
                            color: Colors.transparent,
                            child: new Icon(
                              Icons.delete_outline,
                              color: Colors.black87,
                            ),
                          ),
                          onTap: () => _onDeleteProfile(widget.profile.id),
                        ),
                      ),
                    )
                  : new Container(),
            ],
          ),
          new Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: new SubtitleLabel(
              text: widget.profile.breed,
              icon: Icons.pets,
            ),
          ),
          widget.profile.hobby != ""
              ? new Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: new SubtitleLabel(
                    text: widget.profile.hobby,
                    icon: IconData(0xe900, fontFamily: "tennis_ball"),
                  ),
                )
              : new Container(),
        ],
      ),
    );
  }

  void _onDeleteProfile(String userID) async {
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
        if (delete != null) {
          Navigator.of(context).pop(delete);
          SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
        }
      },
    );
  }

  Widget _buildProfileBio() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      child: new Text(
        widget.profile.bio,
        style: TextStyle(
          color: Colors.black.withOpacity(0.6),
          fontSize: 18.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageButton() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      child: new GestureDetector(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Icon(
              Icons.message,
              color: Colors.purple,
            ),
            new Container(width: 5.0),
            new Text(
              "MESSAGE ${widget.profile.name.toUpperCase()}",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 16.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
                wordSpacing: 3.0,
              ),
            ),
          ],
        ),
        onTap: _showMessages,
      ),
    );
  }

  void _showMessages() async {
    final conversations = await Firestore.instance
        .collection("conversations")
        .where("users", arrayContains: widget.currentDog.id)
        .getDocuments();

    final conversation = conversations.documents.isNotEmpty
        ? conversations.documents.toSet().singleWhere(
            (conversationElement) =>
                List.from(conversationElement.data["users"])
                    .contains(widget.profile.id),
            orElse: () => null)
        : null;

    if (conversation != null) {
      final conversationID = conversation.documentID;

      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (BuildContext context) => new MessagesPage(
            currentDog: widget.currentDog,
            otherDog: widget.profile,
            user: widget.currentUser,
            conversation: new Conversation(
              users: [widget.currentUser, widget.profile.id],
              id: conversationID,
            ),
          ),
        ),
      );
    } else {
      final conversationRef =
          await Firestore.instance.collection("conversations").add(
        {
          "users": [widget.currentDog.id, widget.profile.id],
          "lastMessage": null,
          "messageRead": {
            widget.currentDog.id: true,
            widget.profile.id: true,
          },
        },
      );
      await conversationRef.setData({
        "id": conversationRef.documentID,
      }, merge: true);

      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (BuildContext context) => new MessagesPage(
            currentDog: widget.currentDog,
            otherDog: widget.profile,
            user: widget.currentUser,
            conversation: new Conversation(
              users: [widget.currentUser, widget.profile.id],
              id: conversationRef.documentID,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildReportButton() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: new GestureDetector(
        child: new Text(
          "REPORT ${widget.profile.name}".toUpperCase(),
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w600,
              wordSpacing: 3.0),
        ),
        onTap: _showReportOptions,
      ),
    );
  }

  Future<Null> _showReportOptions() async {
    final List<String> reportOptions = [
      "Made me uncomfortable",
      "Inappropriate content",
      "Stolen photo",
    ];

    SystemChrome.setEnabledSystemUIOverlays([]);

    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return new SafeArea(
          bottom: true,
          child: new Material(
            type: MaterialType.transparency,
            child: new Container(
              height: 250.0,
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
                      "REPORT",
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
                      text: reportOptions[0],
                      icon: Icons.sentiment_dissatisfied,
                      enabled: false,
                      onPressed: () {
                        Navigator.of(context).pop(0);
                      },
                    ),
                  ),
                  new Expanded(
                    child: new ActionSheetButton(
                      text: reportOptions[1],
                      icon: Icons.report_problem,
                      enabled: false,
                      onPressed: () {
                        Navigator.of(context).pop(1);
                      },
                    ),
                  ),
                  new Expanded(
                    child: new ActionSheetButton(
                      text: reportOptions[2],
                      icon: Icons.camera_enhance,
                      enabled: false,
                      onPressed: () {
                        Navigator.of(context).pop(2);
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
        _reportDog(reportOptions[index]);
      }
    });
  }

  void _reportDog(String reportOption) {
    final dogRef =
        Firestore.instance.collection("dogs").document(widget.profile.id);
    try {
      Firestore.instance.runTransaction((Transaction tx) async {
        final dogSnapshot = await tx.get(dogRef);
        if (dogSnapshot.exists) {
          final Map<String, dynamic> reports =
              Map.from(dogSnapshot.data["reports"]);
          if (!reports.containsKey(widget.currentUser)) {
            reports.addAll({widget.currentUser: reportOption});
            print("REPORTS: $reports");
            tx.update(dogRef, {"reports": reports});
          }
        }
      });
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          new ListView(
            padding: EdgeInsets.only(bottom: 100.0),
            shrinkWrap: true,
            children: <Widget>[
              _buildProfileCard(),
              _buildProfileInfo(),
              widget.profile.bio != "" ? _buildProfileBio() : new Container(),
              widget.currentDog != null && widget.profile.owner != widget.currentUser
                  ? _buildMessageButton()
                  : new Container(),
              widget.currentUser != widget.profile.owner ? _buildReportButton() : new Container(),
            ],
          ),
        ],
      ),
    );
  }
}
