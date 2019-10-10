import 'package:fetch/pages/photo_viewer_page.dart';
import 'package:fetch/transitions.dart';
import 'package:flutter/material.dart';
import 'package:fetch/models/message.dart';

class MessageCell extends StatelessWidget {
  final String currentDog;
  final Message message;
  final Message previousMessage;
  final Message nextMessage;
  final bool messageSent;
  final BuildContext context;

  MessageCell(
      {this.currentDog, this.message, this.previousMessage, this.nextMessage, this.context})
      : messageSent = message.user == currentDog ? true : false;

  BorderRadiusGeometry _buildBorderRadius() {
    final defaultBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
      bottomRight: messageSent ? Radius.circular(0.0) : Radius.circular(10.0),
      bottomLeft: messageSent ? Radius.circular(10.0) : Radius.circular(0.0),
    );

    if (previousMessage != null && nextMessage != null) {
      // MIDDLE MESSAGE
      if (message.user == previousMessage.user) {
        return BorderRadius.only(
          topLeft: messageSent ? Radius.circular(10.0) : Radius.circular(0.0),
          topRight: messageSent ? Radius.circular(0.0) : Radius.circular(10.0),
          bottomRight:
              messageSent ? Radius.circular(0.0) : Radius.circular(10.0),
          bottomLeft:
              messageSent ? Radius.circular(10.0) : Radius.circular(0.0),
        );
      } else {
        return defaultBorderRadius;
      }
    } else if (previousMessage != null && nextMessage == null) {
      // BOTTOM MESSAGE
      if (message.user == previousMessage.user) {
        return BorderRadius.only(
          topLeft: messageSent ? Radius.circular(10.0) : Radius.circular(0.0),
          topRight: messageSent ? Radius.circular(0.0) : Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        );
      } else {
        return defaultBorderRadius;
      }
    } else {
      // TOP MESSAGE
      return BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomRight: messageSent ? Radius.circular(0.0) : Radius.circular(10.0),
        bottomLeft: messageSent ? Radius.circular(10.0) : Radius.circular(0.0),
      );
    }
  }

  Widget _buildMessageContent() {
    if (message.body != null && message.body.isNotEmpty) {
      return new Text(
        message.body,
        style: TextStyle(
          color: messageSent ? Colors.white : Colors.black,
          fontSize: 16.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (message.photo != null) {
      return new GestureDetector(
              child: new AspectRatio(
          aspectRatio: 3.0 / 4.0,
          child: new Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: _buildBorderRadius(),
              image: DecorationImage(
                image: NetworkImage(
                  message.photo,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            SlideUpRoute(
              page: PhotoViewerPage(
                photo: message.photo,
              ),
            ),
          );
        }
      );
    } else {
      return new AspectRatio(
        aspectRatio: 3.0 / 4.0,
        child: new Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: _buildBorderRadius(),
          ),
          child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return new Align(
          alignment: messageSent ? Alignment.topRight : Alignment.topLeft,
          child: new Container(
            padding: EdgeInsets.all(8.0),
            constraints: BoxConstraints(
              maxWidth: (constraints.maxWidth / 2) + 50.0,
            ),
            decoration: BoxDecoration(
              color: messageSent
                  ? Theme.of(context).primaryColor
                  : Color.fromRGBO(229, 229, 234, 1.0),
              // Blue Color:  Colors.lightBlueAccent.withOpacity(0.4),
              // Gray Color: Color.fromRGBO(229, 229, 234, 1.0),
              borderRadius: _buildBorderRadius(),
            ),
            child: _buildMessageContent(),
          ),
        );
      },
    );
  }
}
