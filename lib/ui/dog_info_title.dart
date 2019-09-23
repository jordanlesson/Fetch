import 'package:flutter/material.dart';

class DogInfoTitle extends StatelessWidget {
  final String title;

  DogInfoTitle({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: new Text(
        title,
        style: TextStyle(
            color: Colors.black87,
            fontSize: 20.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            ),
      ),
    );
  }
}
