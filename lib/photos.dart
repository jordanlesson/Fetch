import 'dart:typed_data';

import 'package:flutter/material.dart';

class PhotoBrowser extends StatefulWidget {
  final List<dynamic> photos;
  final int visiblePhotoIndex;
  final Function nextImage;
  final Function previousImage;

  PhotoBrowser(
      {this.photos,
      this.visiblePhotoIndex,
      this.nextImage,
      this.previousImage});

  @override
  _PhotoBrowserState createState() => _PhotoBrowserState();
}

class _PhotoBrowserState extends State<PhotoBrowser> {
  int visiblePhotoIndex;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
  }

  @override
  void didUpdateWidget(PhotoBrowser oldWidget) {
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
    });
    widget.previousImage();
  }

  void _nextImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex < widget.photos.length - 1
          ? visiblePhotoIndex + 1
          : visiblePhotoIndex;
    });
    widget.nextImage();
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
            child: new Container(
              color: Colors.transparent,
            ),
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

  @override
  Widget build(BuildContext context) {

    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        widget.photos[visiblePhotoIndex] is String ? new Image.network(
          widget.photos[visiblePhotoIndex],
          fit: BoxFit.cover,
        ) : new Image.memory(
          widget.photos[visiblePhotoIndex],
          fit: BoxFit.cover,
        ),
        new Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: new SelectedPhotoIndicator(
            photoCount: widget.photos.length,
            visiblePhotoIndex: visiblePhotoIndex,
          ),
        ),
        _buildPhotoControls(),
      ],
    );
  }
}

class SelectedPhotoIndicator extends StatelessWidget {
  final int photoCount;
  final int visiblePhotoIndex;

  SelectedPhotoIndicator({this.photoCount, this.visiblePhotoIndex});

  Widget _buildActiveIndicator() {
    return new Expanded(
      child: new Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: new Container(
          height: 3.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0x22000000),
                spreadRadius: 0.0,
                blurRadius: 2.0,
                offset: const Offset(0.0, 1.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInactiveIndicator() {
    return new Expanded(
      child: new Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: new Container(
          height: 3.0,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < photoCount; i++) {
      indicators.add(
        i == visiblePhotoIndex
            ? _buildActiveIndicator()
            : _buildInactiveIndicator(),
      );
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(8.0),
      child: new Row(
        children: _buildIndicators(),
      ),
    );
  }
}

class ProfilePhotoBrowser extends StatefulWidget {
  final List<dynamic> photos;
  final int visiblePhotoIndex;

  ProfilePhotoBrowser({this.photos, this.visiblePhotoIndex});

  @override
  _ProfilePhotoBrowserState createState() => _ProfilePhotoBrowserState();
}

class _ProfilePhotoBrowserState extends State<ProfilePhotoBrowser> {
  int visiblePhotoIndex;
  PageController profilePhotoController;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
    profilePhotoController = PageController(initialPage: visiblePhotoIndex);
  }

  @override
  void didUpdateWidget(ProfilePhotoBrowser oldWidget) {
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
                widget.photos[index] is String ? new Image.network(
                  widget.photos[index],
                  fit: BoxFit.cover,
                ) : new Image.memory(
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
              )),
        ),
      ],
    );
  }
}
