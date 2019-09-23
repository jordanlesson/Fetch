import 'package:flutter/material.dart';

class InputTitle extends StatelessWidget {
  final String title;

  InputTitle({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: new Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
