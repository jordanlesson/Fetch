import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fetch/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:fetch/ui/profile_photo_card.dart';
import 'package:fetch/gallery_image.dart';
import 'package:reorderables/reorderables.dart';
import 'photo_capture_page.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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

  void _onPhotoReordered(int startIndex, int endIndex) {
    final Uint8List photo = photos[startIndex];
    final int photosLength = photos.length;
    setState(() {
      photos.removeAt(startIndex);
      if (endIndex > photosLength) {
        photos.insert(photosLength - 1, photo);
      } else if (endIndex > startIndex) {
        photos.insert(endIndex - 1, photo);
      } else if (startIndex > endIndex) {
        photos.insert(endIndex, photo);
      }
    });
  }

  Widget _buildPhotoGrid() {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ReorderableWrap(
          padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 10.0),
          maxMainAxisCount: 3,
          minMainAxisCount: 3,
          verticalDirection: VerticalDirection.down,
          needsLongPressDraggable: true,
          spacing: 0.0,
          runSpacing: 0.0,
          runAlignment: WrapAlignment.spaceEvenly,
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          onReorder: _onPhotoReordered,
          children: List<Widget>.generate(9, (int index) {
            return new GestureDetector(
              child: new Container(
                width: (constraints.maxWidth - 30) / 3,
                height: ((constraints.maxWidth - 30) / 3) * 4 / 3,
                child: new ProfilePhotoCard(
                  image: photos.length >= index + 1 ? photos[index] : null,
                  isFirstPhoto:
                      photos.length >= index + 1 && index == 0 ? true : false,
                  onIconPressed: () => _handlePhoto(index),
                ),
              ),
              onTap: () => _showPhotoOptions(index),
            );
          }),
        );
      },
    );
  }

  Future<Null> _showPhotoOptions(int photoIndex) async {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return new SafeArea(
          bottom: true,
          top: false,
          child: new Material(
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
          ),
        );
      },
    ).then(
      (index) {
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

        if (index != null) {
        Future.delayed(
          Duration(milliseconds: 200),
          () async {
            File photoFile;

            if (index == 0) {
              final cameras = await availableCameras();

              Navigator.of(context)
                  .push(
                SlideUpRoute(
                  page: PhotoCapturePage(
                    camera: cameras.first,
                  ),
                ),
              )
                  .then((photoPath) async {
                if (photoPath != null) {
                  photoFile = File(photoPath);

                  if (photoFile != null) {
                    final photoBytes = await photoFile.readAsBytes();
                    final decodedPhoto = await decodeImageFromList(photoBytes);
                    print("height: ${decodedPhoto.height}");
                    print("width: ${decodedPhoto.width}");
                    if (decodedPhoto.height * decodedPhoto.width <=
                        2048 * 2048) {
                      final photo = new Uint8List.fromList(photoBytes);
                      _onPhotoSelected(GalleryImage(bytes: photo), photoIndex);
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        _buildUploadError(),
                      );
                    }
                  }
                }
              });
            } else {
              photoFile = await ImagePicker.pickImage(
                  source: ImageSource.gallery,
                  maxHeight: 640.0,
                  maxWidth: 480.0);
            }
            if (photoFile != null) {
              final photoBytes = await photoFile.readAsBytes();
              final decodedPhoto = await decodeImageFromList(photoBytes);
              print("height: ${decodedPhoto.height}");
              print("width: ${decodedPhoto.width}");
              if (decodedPhoto.height * decodedPhoto.width <= 2048 * 2048) {
                final photo = new Uint8List.fromList(photoBytes);
                _onPhotoSelected(GalleryImage(bytes: photo), photoIndex);
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  _buildUploadError(),
                );
              }
            }
          },
        );
      }
      },
    );
  }

  Widget _buildUploadError() {
    return new SnackBar(
      backgroundColor: Colors.red,
      content: new Container(
        height: 30.0,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: new Text(
          "Photo size must be less than 2048 x 2048",
          maxLines: null,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ),
    );
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
              key: _scaffoldKey,
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
                  new Center(
                    child: _buildPhotoGrid(),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
