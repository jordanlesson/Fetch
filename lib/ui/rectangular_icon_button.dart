import 'package:flutter/material.dart';

class RectangularIconButton extends StatelessWidget {

  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  RectangularIconButton({
    this.icon,
    this.iconColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RawMaterialButton(
        child: new Icon(
          icon,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}