import 'package:flutter/material.dart';

class TextActionButton extends StatelessWidget {

  final String text;
  final Color color;
  final bool disabled;
  final VoidCallback onPressed;

  TextActionButton({
    this.text,
    this.color,
    this.disabled = false,
    this.onPressed,
  }) : assert(disabled != null);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: 10.0),
        child: new Text(
          text,
          style: TextStyle(
              color: disabled ? Colors.black38 : color,
              fontFamily: "Proxima Nova",
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              ),
        ),
      ),
      onTap: disabled ? () => null : onPressed,
    );
  }
}
