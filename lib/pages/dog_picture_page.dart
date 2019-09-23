import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fetch/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:fetch/ui/profile_photo_card.dart';
import 'package:fetch/gallery_image.dart';
import 'photo_gallery_page.dart';
import 'dog_gender_page.dart';
import 'package:fetch/transitions.dart';
import 'package:fetch/blocs/sign_up_bloc/bloc.dart';
import 'package:fetch/resources/user_repository.dart';

class DogPicturePage extends StatefulWidget {
  final String name;
  final DateTime dateOfBirth;

  DogPicturePage({@required this.name, @required this.dateOfBirth});

  @override
  _DogPicturePageState createState() => _DogPicturePageState();
}

class _DogPicturePageState extends State<DogPicturePage> {
  List<Uint8List> photos;
  bool dogPhotosValid;

  final UserRepository _userRepository = new UserRepository();

  SignUpBloc _signUpBloc;

  @override
  void initState() {
    super.initState();
    photos = new List<Uint8List>();

    dogPhotosValid = false;

    _signUpBloc = SignUpBloc(userRepository: _userRepository);
  }

  @override
  void dispose() { 
    _signUpBloc.dispose();
    super.dispose();
  }

  Widget _buildAppBar(SignUpState state) {

    return new AppBar(
      backgroundColor: Colors.white,
      title: new Icon(
      IconData(0xe900, fontFamily: "fetch"),
        color: Theme.of(context).primaryColor,
      ),
      centerTitle: true,
      leading: new BackButton(
        color: Theme.of(context).primaryColor,
      ),
      actions: <Widget>[
        new TextActionButton(
          color: Theme.of(context).primaryColor,
          text: "Next",
          disabled: !state.isPhotosValid,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => new DogGenderPage(
                  name: widget.name,
                  dateOfBirth: widget.dateOfBirth,
                  photos: photos,
                ),
              ),
            );
          },
        ),
      ],
      elevation: 0.0,
    );
  }

  Widget _buildTitle() {
    return new Text(
      "Add Photos of Your Dog",
      style: TextStyle(
        color: Colors.black87,
        fontSize: 20.0,
        fontFamily: "Proxima Nova",
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return new GridView.builder(
      padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 10.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 0.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new ProfilePhotoCard(
            image: photos.length >= index + 1 ? photos[index] : null,
            isFirstPhoto:
                photos.length >= index + 1 && index == 0 ? true : false,
            onIconPressed: () => _handlePhoto(index),
          ),
          onTap: () => _showPhotoOptions(index),
        );
      },
      itemCount: 9,
    );
  }

  Future<Null> _showPhotoOptions(int photoIndex) async {

    SystemChrome.setEnabledSystemUIOverlays([]);

    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return new Material(
          type: MaterialType.transparency,
          child: new Container(
            height: 200.0,
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Container(
                  height: 35.0,
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  child: new Text(
                    "MEDIA",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12.0,
                      fontFamily: "Proxima Nova",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                new Expanded(
                  child: new ActionSheetButton(
                    text: "Take Photo",
                    icon: Icons.camera_alt,
                    enabled: false,
                    onPressed: () {
                      Navigator.of(context).pop(0);
                    },
                  ),
                ),
                new Expanded(
                  child: new ActionSheetButton(
                    text: "Choose from Gallery",
                    icon: Icons.photo_library,
                    enabled: false,
                    onPressed: () {
                      Navigator.of(context).pop(1);
                    },
                  ),
                ),
                new GestureDetector(
                  child: new Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(
                        5.0,
                      ),
                    ),
                    child: new Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((index) {

      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

      if (index != null) {
      Future.delayed(Duration(milliseconds: 200), () async {

          final photoFile = await ImagePicker.pickImage(
              source: index == 0 ? ImageSource.camera : ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
          if (photoFile != null) {
            final photoBytes = await photoFile.readAsBytes();
            final photo = new Uint8List.fromList(photoBytes);
            _onPhotoSelected(GalleryImage(bytes: photo), photoIndex);
          }
        // else if (index == 1) {
        //   Navigator.of(context)
        //       .push(
        //         SlideUpRoute(
        //           page: PhotoGalleryPage(),
        //         ),
        //       )
        //       .then((photo) => _onPhotoSelected(photo, photoIndex));
        // }
      });
      }
    });
  }

  void _handlePhoto(int photoIndex) {
    if (photos.length >= photoIndex + 1 && photoIndex != 0) {
      setState(() {
        photos.removeAt(photoIndex);
      });
    } else {
      _showPhotoOptions(photoIndex);

      // Navigator.of(context)
      //     .push(
      //       MaterialPageRoute(
      //         builder: (BuildContext context) => new PhotoGalleryPage(),
      //       ),
      //     )
      //     .then((photo) => _onPhotoSelected(photo, photoIndex));
    }
  }

  void _onPhotoSelected(GalleryImage photo, int photoIndex) {
    if (photo != null) {
      setState(() {
        if (photos.length != 9) {
          if (photos.length != 0 && photoIndex == 0) {
            photos.removeAt(photoIndex);
            photos.insert(photoIndex, photo.bytes);
          } else if (photos.length >= photoIndex + 1) {
            photos.removeAt(photoIndex);
            photos.insert(photoIndex, photo.bytes);
          } else {
            photos.add(photo.bytes);
          }
        } else {
          photos.removeAt(photoIndex);
          photos.insert(photoIndex, photo.bytes);
        }
      });

      _signUpBloc.dispatch(
        PhotosChanged(
          photos: photos,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new BlocProvider(
      bloc: _signUpBloc,
      child: new BlocBuilder(
          bloc: _signUpBloc,
          builder: (BuildContext context, SignUpState state) {
            return new Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: _buildAppBar(state),
              body: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _buildTitle(),
                  ),
                  _buildPhotoGrid(),
                ],
              ),
            );
          }),
    );
  }
}
