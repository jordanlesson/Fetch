import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:fetch/pages/dog_breed_page.dart';
import 'package:fetch/pages/photo_capture_page.dart';
import 'package:fetch/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reorderables/reorderables.dart';
import 'date_of_birth_info_page.dart';
import 'hobby_info_page.dart';
import 'photo_gallery_page.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:fetch/ui/tab_bar_item.dart';
import 'package:fetch/ui/profile_info_input.dart';
import 'package:fetch/ui/input_title.dart';
import 'package:fetch/ui/profile_photo_card.dart';
import 'package:fetch/models/profile.dart';
import 'package:fetch/cards.dart';
import 'package:fetch/gallery_image.dart';
import 'package:fetch/transitions.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlay, rootBundle;
import 'package:permission/permission.dart';

class ProfileInfoPage extends StatefulWidget {
  final Profile profile;
  final Uint8List profileImage;
  final String currentUser;

  ProfileInfoPage(
      {@required this.profile,
      @required this.profileImage,
      @required this.currentUser});

  @override
  _ProfileInfoPageState createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage>
    with SingleTickerProviderStateMixin {
  TabController profileTabController;
  int tabBarIndex;
  Profile profile;
  final UserRepository _userRepository = new UserRepository();
  String hobby;
  String bio;
  List<dynamic> photos;
  List<dynamic> originalPhotos;

  @override
  void initState() {
    super.initState();

    tabBarIndex = 0;

    photos = List<dynamic>.from(widget.profile.photos);

    originalPhotos = List<dynamic>.from(photos);

    profile = new Profile(
      hobby: widget.profile.hobby,
      bio: widget.profile.bio,
      owner: widget.profile.owner,
      name: widget.profile.name,
      photoPaths: widget.profile.photoPaths,
      photos: photos,
      breed: widget.profile.breed,
      gender: widget.profile.gender,
      dateOfBirth: widget.profile.dateOfBirth,
      id: widget.profile.id,
      likes: widget.profile.likes,
      treats: widget.profile.treats,
      likeCount: widget.profile.likeCount,
      treatCount: widget.profile.treatCount,
    );

    hobby = profile.hobby;
    bio = profile.bio;

    // _fetchDogImages();

    profileTabController = TabController(
      vsync: this,
      initialIndex: tabBarIndex,
      length: 2,
    );
  }

  // void _fetchDogImages() async {
  //   photos = await _userRepository.fetchDogImages(profile);
  //   setState(() {});
  // }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        tabBarIndex == 0 ? "Edit Info" : "Preview",
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Proxima Nova",
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        TextActionButton(
          text: "Done",
          color: Color.fromRGBO(0, 122, 255, 1.0),
          onPressed: () {
            _userRepository.updateDogProfile(
              Profile(
                hobby: hobby,
                bio: bio,
                id: profile.id,
                name: profile.name,
                breed: profile.breed,
                dateOfBirth: profile.dateOfBirth,
              ),
              photos,
              originalPhotos,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
      // bottom: PreferredSize(
      //   child: new Container(
      //     color: Colors.black12,
      //     height: 1.0,
      //   ),
      //   preferredSize: Size.fromHeight(1.0),
      // ),
      elevation: 0.0,
    );
  }

  Widget _buildTabBar() {
    return new Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Expanded(
            child: new TabBarItem(
              text: "Edit",
              color: tabBarIndex == 0
                  ? Color.fromRGBO(0, 122, 255, 1.0)
                  : Colors.black38,
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  tabBarIndex = 0;
                });
              },
            ),
          ),
          new Container(
            width: 1.0,
            height: 30.0,
            color: Colors.black12,
            margin: EdgeInsets.symmetric(vertical: 5.0),
          ),
          new Expanded(
            child: new TabBarItem(
              text: "Preview",
              color: tabBarIndex == 1
                  ? Color.fromRGBO(0, 122, 255, 1.0)
                  : Colors.black38,
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  tabBarIndex = 1;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPhotosChanged(List<dynamic> editedPhotos) {
    setState(() {
      photos = editedPhotos;
      profile.photos = photos;
    });
  }

  void _onNameChanged(String name) {
    setState(() {
      profile.name = name;
    });
  }

  void _onBreedChanged(String breed) {
    setState(() {
      profile.breed = breed;
    });
  }

  void _onDateOfBirthChanged(DateTime dateOfBirth) {
    setState(() {
      profile.dateOfBirth = dateOfBirth;
    });
  }

  void _onBioChanged(String editedBio) {
    setState(() {
      bio = editedBio;
      profile.bio = bio;
    });
  }

  void _onHobbyChanged(String editedHobby) {
    setState(() {
      hobby = editedHobby;
      profile.hobby = hobby;

      print("HOBBY: $hobby");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Scaffold(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
        appBar: _buildAppBar(),
        body: new Column(
          children: <Widget>[
            _buildTabBar(),
            tabBarIndex == 0
                ? ProfileEditPage(
                    profile: profile,
                    photos: photos,
                    hobby: hobby,
                    bio: bio,
                    onPhotosChanged: _onPhotosChanged,
                    onNameChanged: _onNameChanged,
                    onBreedChanged: _onBreedChanged,
                    onDateOfBirthChanged: _onDateOfBirthChanged,
                    onBioChanged: _onBioChanged,
                    onHobbyChanged: _onHobbyChanged,
                  )
                : ProfilePreviewPage(
                    profile: profile,
                    currentUser: widget.currentUser,
                  ),
          ],
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();

  final Profile profile;
  final List<dynamic> photos;
  final String hobby;
  final String bio;
  final void Function(List<dynamic>) onPhotosChanged;
  final void Function(String) onNameChanged;
  final void Function(String) onBreedChanged;
  final void Function(DateTime) onDateOfBirthChanged;
  final void Function(String) onBioChanged;
  final void Function(String) onHobbyChanged;

  ProfileEditPage({
    this.profile,
    this.hobby,
    this.bio,
    this.photos,
    this.onPhotosChanged,
    this.onNameChanged,
    this.onBreedChanged,
    this.onDateOfBirthChanged,
    this.onBioChanged,
    this.onHobbyChanged,
  });
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  List<dynamic> photos;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    photos = List<dynamic>.from(widget.photos);
  }

  @override
  void didUpdateWidget(ProfileEditPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      setState(() {
        photos = widget.photos;
      });
    }
  }

  void _onPhotoReordered(int startIndex, int endIndex) {
    final dynamic photo = photos[startIndex];
    final int photosLength = photos.length;
    photos.removeAt(startIndex);
    if (endIndex > photosLength) {
      photos.insert(photosLength - 1, photo);
    } else if (endIndex > startIndex) {
      photos.insert(endIndex - 1, photo);
    } else if (startIndex > endIndex) {
      photos.insert(endIndex, photo);
    }
    widget.onPhotosChanged(photos);
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
                height: ((constraints.maxWidth - 30) / 3) * (4 / 3),
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
    ).then((index) async {
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
                    // if (decodedPhoto.height * decodedPhoto.width <=
                    //     5000 * 5000) {
                      final photo = new Uint8List.fromList(photoBytes);
                      _onPhotoSelected(GalleryImage(bytes: photo), photoIndex);
                    // } else {
                    //   _scaffoldKey.currentState.showSnackBar(
                    //     _buildUploadError(),
                    //   );
                    // }
                  }
                }
              });
            } else {
              photoFile = await ImagePicker.pickImage(
                  source: ImageSource.gallery,
                  );
            }
            if (photoFile != null) {
              final photoBytes = await photoFile.readAsBytes();
              final decodedPhoto = await decodeImageFromList(photoBytes);
              print("height: ${decodedPhoto.height}");
              print("width: ${decodedPhoto.width}");
              // if (decodedPhoto.height * decodedPhoto.width <= 5000 * 5000) {
                final photo = new Uint8List.fromList(photoBytes);
                _onPhotoSelected(GalleryImage(bytes: photo), photoIndex);
              // } 
              // else {
              //   _scaffoldKey.currentState.showSnackBar(
              //     _buildUploadError(),
              //   );
              // }
            }
          },
        );
      }
    });
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
      photos.removeAt(photoIndex);
      widget.onPhotosChanged(photos);
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
      widget.onPhotosChanged(photos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Scaffold(
        key: _scaffoldKey,
        body: new ListView(
          padding: EdgeInsets.only(bottom: 50.0),
          children: <Widget>[
            _buildPhotoGrid(),
            ProfileInfoInput(
              initialText: widget.profile.name,
              hintText: "",
              labelText: "NAME",
              maxHeight: 50.0,
              maxLength: 30,
              maxLines: 1,
              onTextChanged: widget.onNameChanged,
            ), 
            new Divider(
              color: Colors.transparent,
              height: 10.0,
            ),  
            ProfileInfoOptionsButton(
              labelText: "BREED",
              hintText: "Select Your Dog's Breed",
              selectedValue: widget.profile.breed,
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => new DogBreedPage(),
                      ),
                    )
                    .then((breed) => widget.onBreedChanged(breed));
              },
            ),
            new Divider(
              color: Colors.transparent,
              height: 10.0,
            ),  
            ProfileInfoOptionsButton(
              labelText: "DATE OF BIRTH",
              hintText: "Select Your Dog's Date of Birth",
              selectedValue: DateFormat("MM/dd/yyyy").format(widget.profile.dateOfBirth),
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => new DateOfBirthInfoPage(
                          dateOfBirth: widget.profile.dateOfBirth,
                        ),
                      ),
                    )
                    .then((dateOfBirth) => widget.onDateOfBirthChanged(dateOfBirth));
              },
            ),
            new Divider(
              color: Colors.transparent,
              height: 10.0,
            ),  
            ProfileInfoInput(
              initialText: widget.profile.bio,
              hintText: "",
              labelText: "ABOUT MY DOG",
              maxHeight: 350.0,
              maxLength: 500,
              maxLines: null,
              onTextChanged: widget.onBioChanged,
            ),
            new Divider(
              color: Colors.transparent,
              height: 10.0,
            ),  
            ProfileInfoOptionsButton(
              labelText: "HOBBIES",
              hintText: "Select Your Dog's Favorite Hobby",
              selectedValue: widget.hobby,
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => new HobbyInfoPage(
                          hobby: widget.hobby,
                        ),
                      ),
                    )
                    .then((hobby) => widget.onHobbyChanged(hobby));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePreviewPage extends StatelessWidget {
  final Profile profile;
  final String currentUser;

  ProfilePreviewPage({@required this.profile, @required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
        alignment: Alignment.center,
        child: new Hero(
          tag: "Profile Image",
          child: new ProfileCard(
            currentUser: currentUser,
            profile: profile,
            isDecidable: false,
          ),
        ),
      ),
    );
  }
}

class ProfileInfoOptionsButton extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String selectedValue;
  final VoidCallback onPressed;

  ProfileInfoOptionsButton({
    this.labelText,
    this.hintText,
    this.selectedValue,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InputTitle(
          title: labelText,
        ),
        new GestureDetector(
          child: new Container(
            height: 50.0,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Text(
                    selectedValue != null ? selectedValue : hintText,
                    style: TextStyle(
                      color: selectedValue != null ? Colors.black : Colors.black45,
                      fontSize: 17.0,
                      fontFamily: "Proxima Nova",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black26,
                  size: 17.0,
                ),
              ],
            ),
          ),
          onTap: onPressed,
        ),
      ],
    );
  }
}
