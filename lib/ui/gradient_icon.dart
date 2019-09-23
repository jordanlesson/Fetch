import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  final Icon icon;

  GradientIcon({@required this.icon});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            Color.fromRGBO(0, 122, 255, 1.0),
            Color.fromRGBO(0, 175, 230, 1.0),
            Color.fromRGBO(0, 255, 230, 1.0),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: new Icon(
        Icons.pets,
      ),
    );
  }
}
