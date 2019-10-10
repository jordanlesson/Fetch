import 'package:flutter/material.dart';
import 'package:fetch/photos.dart';
import 'package:fetch/models/profile.dart';

class ProfileView extends StatefulWidget {

  final Profile profile;

  ProfileView({Key key, this.profile}) : super(key: key);


  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  int _visiblePhotoIndex;
  ProfilePhotoBrowser photoBrowser;

  @override
  void initState() { 
    super.initState();
    _visiblePhotoIndex = 0;

  }

  Widget _buildBackground() {
    return new ProfilePhotoBrowser(
      photos: widget.profile.photos,
      visiblePhotoIndex: _visiblePhotoIndex,
    );
  }

  @override           
  Widget build(BuildContext context) {
    return Container(
      child: new Material(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildBackground(),
            ],
          ),
        ),
    );
  }
}