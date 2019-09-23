import 'package:flutter/material.dart';

import 'horizontal_divider.dart';

class SideMenuButton extends StatelessWidget {

  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  SideMenuButton({@required this.text, @required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        height: 60.0,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(
              icon,
              size: 30.0,
              color: Colors.black,
            ),
            new HorizontalDivider(
              width: 16.0,
            ),
            new Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
