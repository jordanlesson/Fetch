import 'package:flutter/material.dart';

class RoundProfileButton extends StatelessWidget {

  final IconData icon;
  final Color color;
  final Color iconColor;
  final Gradient gradient;
  final double size;
  final double iconSize;
  final VoidCallback onPressed;
  

  RoundProfileButton.large({this.icon, this.color, this.gradient, this.iconColor, this.onPressed}) : size = 70.0, iconSize = 35.0;

  RoundProfileButton.small({this.icon, this.color, this.gradient, this.iconColor, this.onPressed}) : size = 60.0, iconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient != null ? gradient
         : null,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(215, 215, 215, 1.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: new RawMaterialButton(
        shape: CircleBorder(),
        elevation: 0.0,
        child: new Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        onPressed: onPressed,
      ),
    );
  }
}