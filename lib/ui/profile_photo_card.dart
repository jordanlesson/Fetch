import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fetch/gallery_image.dart';

class ProfilePhotoCard extends StatefulWidget {
  @override
  _ProfilePhotoCardState createState() => _ProfilePhotoCardState();

  final Uint8List image;
  final bool isFirstPhoto;
  final VoidCallback onIconPressed;

  ProfilePhotoCard({
    this.image,
    this.isFirstPhoto,
    this.onIconPressed,
  });
}

class _ProfilePhotoCardState extends State<ProfilePhotoCard> {
  bool imageProvided;

  @override
  void initState() {
    super.initState();

    imageProvided = widget.image != null;
  }

  @override
  void didUpdateWidget(ProfilePhotoCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      setState(() {
      imageProvided = widget.image != null;
      });
    }
  }

  Widget _buildIcon() {
    if (!imageProvided) {
      return new Icon(
        Icons.add,
        color: Colors.white,
      );
    } else if (imageProvided && widget.isFirstPhoto) {
      return new Icon(
        Icons.edit,
        color: Theme.of(context).primaryColor,
        size: 18.0,
      );
    } else {
      return new Icon(
        Icons.clear,
        color: Theme.of(context).primaryColor,
        size: 20.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: 9.0 / 16.0,
    child: new Container(
      child: new Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.all(8.0),
            decoration: imageProvided
                ? BoxDecoration(
                    color: Color.fromRGBO(235, 235, 235, 1.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.black12,
                      style: BorderStyle.solid,
                    ),
                    image: DecorationImage(
                        image: new MemoryImage(
                          widget.image
                        ),
                        fit: BoxFit.cover,
                        matchTextDirection: true,
                        alignment: Alignment.center,
                        ),
                    borderRadius: BorderRadius.circular(10.0),
                  )
                : BoxDecoration(
                    color: Color.fromRGBO(235, 235, 235, 1.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.black12,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          ),
          new GestureDetector(
            child: new Container(
              height: 28.0,
              width: 28.0,
              decoration: imageProvided
                  ? BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3.0,
                          offset: Offset(0.0, 3.0),
                        ),
                      ],
                      shape: BoxShape.circle,
                    )
                  : BoxDecoration(
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
                        new BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
              child: _buildIcon(),
            ),
            onTap: widget.onIconPressed,
          ),
        ],
      ),
    ),
    );
  }
}
