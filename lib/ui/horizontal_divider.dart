import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {

  final double width;
  
  HorizontalDivider({@required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 0.0,
      width: width,
    );
  }
}