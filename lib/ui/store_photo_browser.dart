import 'package:flutter/material.dart';

import '../photos.dart';

class StorePhotoBrowser extends StatefulWidget {
  final List<dynamic> photos;
  final int visiblePhotoIndex;

  StorePhotoBrowser({this.photos, this.visiblePhotoIndex});

  @override
  _StorePhotoBrowserState createState() => _StorePhotoBrowserState();
}

class _StorePhotoBrowserState extends State<StorePhotoBrowser> {
  int visiblePhotoIndex;
  PageController profilePhotoController;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
    profilePhotoController = PageController(initialPage: visiblePhotoIndex);
  }

  @override
  void didUpdateWidget(StorePhotoBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visiblePhotoIndex != oldWidget.visiblePhotoIndex) {
      setState(() {
        visiblePhotoIndex = widget.visiblePhotoIndex;
      });
    }
  }

  void _previousImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex > 0 ? visiblePhotoIndex - 1 : 0;

      profilePhotoController.jumpToPage(visiblePhotoIndex);
    });
  }

  void _nextImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex < widget.photos.length - 1
          ? visiblePhotoIndex + 1
          : visiblePhotoIndex;

      profilePhotoController.jumpToPage(visiblePhotoIndex);
    });
  }

  Widget _buildPhotoControls() {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new GestureDetector(
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: new Container(color: Colors.transparent),
          ),
          onTap: _previousImage,
        ),
        new GestureDetector(
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: new Container(
              color: Colors.transparent,
            ),
          ),
          onTap: _nextImage,
        ),
      ],
    );
  }

  _onPageChanged(int photoIndex) {
    setState(() {
      visiblePhotoIndex = photoIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new PageView.builder(
          itemBuilder: (BuildContext context, int index) {
            return new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Image.asset(
                        widget.photos[index],
                        fit: BoxFit.cover,
                      ),
                    
                _buildPhotoControls()
              ],
            );
          },
          controller: profilePhotoController,
          itemCount: widget.photos.length,
          onPageChanged: _onPageChanged,
        ),
        new Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: new SafeArea(
            top: true,
            bottom: false,
            child: new SelectedPhotoIndicator(
              photoCount: widget.photos.length,
              visiblePhotoIndex: visiblePhotoIndex,
            ),
          ),
        ),
      ],
    );
  }
}