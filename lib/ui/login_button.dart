import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  LoginButton({
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        height: 60.0,
        margin: EdgeInsets.symmetric(horizontal: 40.0),
        alignment: Alignment.center,
        constraints: BoxConstraints(maxWidth: 350.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(0, 122, 255, 1.0),
              Color.fromRGBO(0, 175, 230, 1.0),
              Color.fromRGBO(0, 255, 230, 1.0),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: new Text(
          text.toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w600),
        ),
      ),
      onTap: onPressed,
    );
  }
}