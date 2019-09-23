import 'package:flutter/material.dart';

class TabBarItem extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final IconData icon;

  TabBarItem({
    this.text,
    this.color,
    this.backgroundColor,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        child: new Container(
          color: backgroundColor,
          alignment: Alignment.center,
          padding: EdgeInsets.all(12.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            icon != null ? new Container(
              margin: EdgeInsets.only(right: 5.0),
              child: new Icon(
                icon,
                color: color,
              ),
            ) : new Container(),
              new Text(
                text,
                style: TextStyle(
                    color: color,
                    fontSize: 20.0,
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
