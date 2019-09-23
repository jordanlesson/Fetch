import 'dart:typed_data';

import 'package:fetch/pages/profile_info_page.dart';
import 'package:fetch/profile.dart';
import 'package:fetch/transitions.dart';
import 'package:flutter/material.dart';
import 'horizontal_divider.dart';

class ProfileHeader extends StatefulWidget {
  final Profile dog;
  final Uint8List profileImage;

  ProfileHeader({@required this.dog, this.profileImage});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Widget _buildProfileImage() {

    print(widget.dog.photos.first);
    return new Center(
      child: new GestureDetector(
        child: new Container(
          height: 140.0,
          width: 140.0,
          child: new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              new Container(
                height: 125.0,
                width: 125.0,
                decoration: widget.dog != null
                    ? BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.dog.photos.first,
                          ),
                          fit: BoxFit.cover,
                        ),
                      )
                    : BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
              ),
              new Align(
                alignment: Alignment.bottomRight,
                child: new Container(
                  height: 62.5,
                  width: 62.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: new Container(
                    height: 42.5,
                    width: 42.5,
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
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            SlideUpRoute(
              page: ProfileInfoPage(
                currentUser: widget.dog.owner,
                profile: widget.dog,
                profileImage: widget.profileImage,
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildProfileTitle() {
    return new Expanded(
      child: new Container(
        alignment: Alignment.center,
        //margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: new Text(
          widget.dog != null
              ? "${widget.dog.name}, ${Profile().convertDate(widget.dog.dateOfBirth)}"
              : "",
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "Gotham Rounded",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStatistics() {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new Container(
              alignment: Alignment.centerRight,
              child: new RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.dog != null
                          ? textFormatter(widget.dog.likeCount)
                          : "   ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: " Likes",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0,
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          new HorizontalDivider(
            width: 10.0,
          ),
          new Expanded(
            child: new Container(
              alignment: Alignment.centerLeft,
              child: new RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.dog != null
                          ? textFormatter(widget.dog.treatCount)
                          : "   ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: " Treats",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0,
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
    return new Expanded(
      flex: 1,
      child: new SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: Colors.black12,
              ),
            ),
          ),
          padding: EdgeInsets.all(8.0),
          child: new Column(
            children: <Widget>[
              _buildProfileImage(),
              _buildProfileTitle(),
              _buildProfileStatistics(),
            ],
          ),
        ),
      ),
    );
  }
}
