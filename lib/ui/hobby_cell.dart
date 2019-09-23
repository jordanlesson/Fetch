import 'package:flutter/material.dart';
import 'check_circle.dart';

class HobbyCell extends StatelessWidget {
  final String hobby;
  final bool selected;

  HobbyCell({
    this.hobby,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      height: 50.0,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              hobby,
              style: TextStyle(
                color: selected ? Theme.of(context).primaryColor : Colors.black,
                fontSize: 17.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          CheckCircle(
            checked: selected,
          ),
        ],
      ),
    );
  }
}
