import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  ProfileTab({this.title, this.icon, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.transparent,
      height: 50.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(right: 3.0),
              child: new Icon(
                icon,
                color: color,
              )
            ),
            new Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 13.0,
            fontFamily: "Gotham Rounded",
            fontWeight: FontWeight.w300,
          ),
        ),
          ],
        ),
      );
    
  }
}