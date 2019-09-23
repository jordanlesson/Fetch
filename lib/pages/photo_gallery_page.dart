// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fetch/ui/text_action_button.dart';
// import 'package:fetch/gallery_image.dart';
// import 'photo_viewer_page.dart';

// class PhotoGalleryPage extends StatefulWidget {
//   @override
//   _PhotoGalleryPageState createState() => _PhotoGalleryPageState();
// }

// class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
//   final _photoChannel = MethodChannel("/gallery");
//   int _photoCount;
//   Map<int, GalleryImage> _photoCache;
//   GalleryImage selectedPhoto;

//   @override
//   void initState() {
//     super.initState();

//     _photoChannel
//         .invokeMethod<int>("getItemCount")
//         .then((count) => setState(() {
//               _photoCount = count;
//               print(_photoCount);
//             }));

//     _photoCache = new Map();
//   }

//   Widget _buildAppBar() {
//     return new AppBar(
//       backgroundColor: Colors.white,
//       title: new Text(
//         "Choose a Photo",
//         style: TextStyle(
//           color: Colors.black,
//           fontFamily: "Proxima Nova",
//           fontSize: 18.0,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       centerTitle: true,
//       actions: <Widget>[
//         TextActionButton(
//           text: "Cancel",
//           color: Color.fromRGBO(0, 122, 255, 1.0),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//       elevation: 0.0,
//     );
//   }

//   Future<GalleryImage> _getPhoto(int photoIndex) async {
//     if (_photoCache[photoIndex] != null) {
//       return _photoCache[photoIndex];
//     } else {
//       var channelResponse =
//           await _photoChannel.invokeMethod("getItem", photoIndex);

//       Map<String, dynamic> photo = Map<String, dynamic>.from(channelResponse);

//       GalleryImage galleryImage = GalleryImage(
//         bytes: photo['data'],
//         id: photo['id'],
//         dateCreated: photo['created'],
//         location: photo['location'],
//       );

//       _photoCache[photoIndex] = galleryImage;

//       return galleryImage;
//     }
//   }

//   Widget _buildPhoto(BuildContext context,
//       AsyncSnapshot<GalleryImage> imageSnapshot, int photoIndex) {
//     if (imageSnapshot?.data != null) {
//       return new GestureDetector(
//         child: GalleryImageCard(
//           image: imageSnapshot.data,
//         ),
//         onTap: () {
//           Navigator.of(context)
//               .push(
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => WillPopScope(
//                         onWillPop: () async {
//                           if (Navigator.of(context).userGestureInProgress)
//                             return false;
//                           else
//                             return true;
//                         },
//                         child: new PhotoViewerPage(
//                           image: imageSnapshot.data,
//                           photoIndex: photoIndex,
//                         ),
//                       ),
//                 ),
//               )
//               .then(_onPhotoSelected);
//         },
//       );
//     } else {
//       return new Container();
//     }
//   }

//   _onPhotoSelected(dynamic photo) {
//     if (photo != null) {
//       Navigator.of(context).pop(photo);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: new GridView.builder(
//         shrinkWrap: true,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4,
//         ),
//         itemBuilder: (BuildContext context, int index) {
//           return new FutureBuilder(
//             future: _getPhoto(index),
//             builder: (BuildContext context,
//                 AsyncSnapshot<GalleryImage> imageSnapshot) {
//               return _buildPhoto(context, imageSnapshot, index);
//             },
//           );
//         },
//         itemCount: _photoCount,
//       ),
//     );
//   }
// }

// class GalleryImageCard extends StatelessWidget {
//   final GalleryImage image;

//   GalleryImageCard({
//     this.image,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return new Hero(
//       tag: image,
//       child: new Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//               image: MemoryImage(
//                 image.bytes,
//               ),
//               fit: BoxFit.cover),
//         ),
//       ),
//     );
//   }
// }
