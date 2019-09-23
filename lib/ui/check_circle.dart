import 'package:flutter/material.dart';

class CheckCircle extends StatelessWidget {
  final bool checked;

  CheckCircle({
    this.checked,
  });

  @override
  Widget build(BuildContext context) {
    if (checked) {
      return new Container(
        height: 17.0,
        width: 17.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 122, 255, 1.0),
          shape: BoxShape.circle,
        ),
        child: new Icon(
          Icons.check,
          size: 13.0,
          color: Colors.white,
        ),
      );
    } else {
      return new Container(
        height: 16.0,
        width: 16.0,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            shape: BoxShape.circle),
      );
    }
  }
}
