import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';

class PhotoDisplayPage extends StatelessWidget {
  final String imagePath;

  PhotoDisplayPage({
    @required this.imagePath,
  });

  Widget _buildBottomBar(BuildContext context) {
    return new BottomAppBar(
      color: Colors.black,
      elevation: 0.0,
      child: new Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white12,
          border: Border(
            top: BorderSide(
              width: 1.0,
              color: Colors.black12,
            ),
          ),
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: new TextActionButton(
                color: Color.fromRGBO(0, 150, 255, 1.0),
                text: "Retake Photo",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            new TextActionButton(
              text: "Use Photo",
              color: Theme.of(context).primaryColor,
              disabled: false,
              onPressed: () {
                Navigator.of(context).pop(imagePath);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageStack(BuildContext context) {
    return new Center(
      child: new AspectRatio(
        aspectRatio: 3.0 / 4.0,
        child: new Container(
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: FileImage(
                File(imagePath),
              ),
              fit: BoxFit.contain,
            ),
          ),
          //child: _buildBackButton(context),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return new GestureDetector(
        child: new Container(
          height: 50.0,
          width: 50.0,
          margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 122, 255, 1.0),
                Color.fromRGBO(0, 150, 255, 1.0),
                Color.fromRGBO(0, 255, 200, 1.0),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 10.0,
                offset: Offset(0.0, 3.0),
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: new Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomBar(context),
      body: _buildImageStack(context),
    );
  }
}