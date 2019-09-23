import 'package:flutter/material.dart';

class SubtitleLabel extends StatelessWidget {
  final String text;
  final IconData icon;

  SubtitleLabel({this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Icon(
          icon,
          size: 15.0,
          color: Colors.black.withOpacity(0.6),
        ),
        new Container(
          width: 5.0,
        ),
        new Text(
          text,
          style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 18.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
