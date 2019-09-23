import 'package:flutter/material.dart';
import 'dart:typed_data';

class MessagePhotoCell extends StatelessWidget {

  final Uint8List photo;
  final VoidCallback onPhotoDeletePressed;

  MessagePhotoCell({@required this.photo, @required this.onPhotoDeletePressed});

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: 3.0 / 4.0,
      child: new Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: MemoryImage(
                  photo,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          new GestureDetector(
            child: new Container(
              height: 20.0,
              width: 20.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: new Icon(
                Icons.clear,
                color: Colors.white,
                size: 16.0,
              ),
            ),
            onTap: onPhotoDeletePressed,
          ),
        ],
      ),
    );
  }
}