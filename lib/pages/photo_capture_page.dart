import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fetch/pages/photo_display_page.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class PhotoCapturePage extends StatefulWidget {
  final CameraDescription camera;

  const PhotoCapturePage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  PhotoCapturePageState createState() => PhotoCapturePageState();
}

class PhotoCapturePageState extends State<PhotoCapturePage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBottomBar() {
    return new Container(
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white12,
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: Colors.black12,
          ),
        ),
      ),
      child: new Stack(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Positioned(
            top: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: new Container(
              padding: EdgeInsets.only(left: 10.0),
              alignment: Alignment.centerLeft,
              child: new TextActionButton(
                text: "Cancel",
                color: Theme.of(context).primaryColor,
                disabled: false,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          new Center(
                      child: new Container(
              height: 60.0,
              width: 60.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: new GestureDetector(
                child: new Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      width: 2.0,
                      color: Colors.black,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: _onPhotoCaptureButtonPressed,
              ),
            ),
          ),
          new Container(),
        ],
      ),
    );
  }

  void _onPhotoCaptureButtonPressed() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Construct the path where the image should be saved using the
      // pattern package.
      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      // Attempt to take a picture and log where it's been saved.
      await _controller.takePicture(path);

      // If the picture was taken, display it on a new screen.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoDisplayPage(imagePath: path),
        ),
      ).then((photoPath) async {
        if (photoPath != null) {
          Navigator.of(context).pop(photoPath);
        } else {
          await _initializeControllerFuture;
        }
      });
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomBar(),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return new CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
