import 'dart:async';
import 'dart:typed_data';

import 'package:fetch/pages/photo_viewer_page.dart';
import 'package:fetch/pages/profile_details_page.dart';
import 'package:fetch/pages/profile_page.dart';
import 'package:fetch/transitions.dart';
import 'package:fetch/ui/message_photo_cell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/horizontal_divider.dart';
import 'package:fetch/ui/message_cell.dart';
import 'package:fetch/conversation.dart';
import 'package:fetch/message.dart';
import 'package:fetch/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();

  final Conversation conversation;
  final Profile currentDog;
  final Profile otherDog;
  final String user;

  MessagesPage(
      {@required this.conversation,
      @required this.currentDog,
      @required this.otherDog,
      @required this.user});
}

class _MessagesPageState extends State<MessagesPage> {
  Offset dragStart;
  Conversation conversation;
  TextEditingController messageTextController;
  bool messageReady;
  StreamController messageStreamController;
  int _dropDownIndex;
  List<Uint8List> messagePhotos;

  @override
  void initState() {
    super.initState();
    conversation = widget.conversation;
    messageTextController = TextEditingController()
      ..addListener(_messageStatusUpdate);
    messageReady = false;

    messagePhotos = new List<Uint8List>();
  }

  @override
  void dispose() {
    messageTextController.dispose();
    super.dispose();
  }

  void _messageStatusUpdate() {
    setState(() {
      messageReady =
          messageTextController.text.isNotEmpty || messagePhotos.isNotEmpty;
    });
  }

  void _sendMessage() async {
    final Message message = new Message(
      user: widget.currentDog.id,
      body: messageTextController.text,
      timeStamp: DateTime.now(),
    );

    final List<Uint8List> photos = List<Uint8List>.from(messagePhotos);

    setState(() {
      messageTextController.clear();
      if (messagePhotos.isNotEmpty) {
        messagePhotos = List<Uint8List>();
      }
    });

    if (photos.isEmpty) {
      _sendText(message);
    } else if (message.body.isEmpty) {
      _sendPhotos(photos, message);
    } else {
      bool photosSent = await _sendPhotos(photos, message);
      if (photosSent) {
        _sendText(message);
      }
    }
  }

  void _sendText(Message message) async {
    final DocumentReference messageRef = await Firestore.instance
        .collection("conversations")
        .document(conversation.id)
        .collection("messages")
        .add({
      "user": message.user,
      "body": message.body,
      "timeStamp": message.timeStamp,
    });

    await messageRef.setData({
      "id": messageRef.documentID,
    }, merge: true);

    final DocumentReference conversationRef = Firestore.instance
        .collection("conversations")
        .document(conversation.id);

    await conversationRef.updateData({
      "lastMessage": {
        "user": message.user,
        "body": message.body,
        "timeStamp": message.timeStamp,
      },
      "messageRead": {
        widget.otherDog.id: false,
        widget.currentDog.id: true,
      }
    });
  }

  Future<bool> _sendPhotos(List<Uint8List> photos, Message message) async {
    List<DocumentReference> photoRefs = List<DocumentReference>();
    try {
      for (Uint8List photo in photos) {
        final int photoIndex = photos.indexOf(photo);

        final DocumentReference photoDocumentRef = await Firestore.instance
            .collection("conversations")
            .document(conversation.id)
            .collection("messages")
            .add({
          "body": null,
          "timeStamp": message.timeStamp,
          "photo": null,
          "user": message.user,
        });

        photoDocumentRef.updateData({
          "id": photoDocumentRef.documentID,
        });

        photoRefs.add(photoDocumentRef);

        if (photoRefs.length == photos.length) {
          final List<String> photoDownloadURLs = List<String>();

          for (Uint8List photoData in photos) {
            final int index = photos.indexOf(photoData);

            final photoStorageRef = FirebaseStorage.instance
                .ref()
                .child("messages")
                .child(photoRefs[index].documentID);

            final photoUpload = photoStorageRef.putData(photoData);
            final uploadComplete = await photoUpload.onComplete;

            final String photoURL = await uploadComplete.ref.getDownloadURL();
            Firestore.instance
                .collection("conversations")
                .document(conversation.id)
                .collection("messages")
                .document(photoRefs[index].documentID)
                .updateData({
              "photo": photoURL,
            });

            final DocumentReference conversationRef = Firestore.instance
                .collection("conversations")
                .document(conversation.id);

            await conversationRef.updateData({
              "lastMessage": {
                "user": message.user,
                "body": "Photo was sent",
                "timeStamp": message.timeStamp,
              },
              "messageRead": {
                widget.otherDog.id: false,
                widget.currentDog.id: true,
              }
            });

            if (index + 1 == photos.length) {
              return true;
            }
          }
        }
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  void _updateMessageRead() async {
    final DocumentReference conversationRef = Firestore.instance
        .collection("conversations")
        .document(conversation.id);

    await conversationRef.updateData({
      "messageRead": {
        widget.otherDog.id: false,
        widget.currentDog.id: true,
      }
    });
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new GestureDetector(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
              height: 30.0,
              width: 30.0,
              margin: EdgeInsets.only(right: 3.0),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    widget.otherDog.photos[0],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new Text(
              widget.otherDog.name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            SlideUpRoute(
              page: ProfileDetailsPage(
                currentDog: widget.currentDog,
                currentUser: widget.user,
                profile: widget.otherDog,
                isDecidable: false,
                visiblePhotoIndex: 0,
              ),
            ),
          );
        },
      ),
      centerTitle: true,
      leading: new BackButton(
        color: Colors.black,
      ),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.more_vert),
          color: Colors.black,
          onPressed: _showReportOptions,
        ),
      ],
      elevation: 0.0,
    );
  }

  Future<Null> _showPhotoOptions() async {
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
    ).then((index) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

      if (index != null) {
        Future.delayed(Duration(milliseconds: 200), () async {
          final photoFile = await ImagePicker.pickImage(
              source: index == 0 ? ImageSource.camera : ImageSource.gallery,
              maxWidth: 1024,
              maxHeight: 1024);
          if (photoFile != null) {
            final photoBytes = await photoFile.readAsBytes();
            final photo = new Uint8List.fromList(photoBytes);
            _onPhotoSelected(photo);
          }
        });
      }
    });
  }

  void _onPhotoSelected(Uint8List photo) {
    messagePhotos.add(photo);
    _messageStatusUpdate();
  }

  Future<Null> _showReportOptions() async {
    final List<String> reportOptions = [
      "Made me uncomfortable",
      "Inappropriate content",
      "Harassed me",
      "Stolen photo",
    ];

    SystemChrome.setEnabledSystemUIOverlays([]);

    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return new SafeArea(
          bottom: true,
          child: new Material(
            type: MaterialType.transparency,
            child: new Container(
              height: 325.0,
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
                      "REPORT & BLOCK",
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
                      text: reportOptions[0],
                      icon: Icons.sentiment_dissatisfied,
                      enabled: false,
                      onPressed: () {
                        Navigator.of(context).pop(0);
                      },
                    ),
                  ),
                  new Expanded(
                    child: new ActionSheetButton(
                      text: reportOptions[1],
                      icon: Icons.report_problem,
                      enabled: false,
                      onPressed: () {
                        Navigator.of(context).pop(1);
                      },
                    ),
                  ),
                  new Expanded(
                    child: new ActionSheetButton(
                      text: reportOptions[2],
                      icon: Icons.announcement,
                      enabled: false,
                      onPressed: () {
                        Navigator.of(context).pop(2);
                      },
                    ),
                  ),
                  new Expanded(
                    child: new ActionSheetButton(
                      text: reportOptions[3],
                      icon: Icons.camera_enhance,
                      enabled: false,
                      onPressed: () {
                        Navigator.of(context).pop(2);
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
    ).then((index) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
      if (index != null) {
        _reportDog(reportOptions[index]);
      }
    });
  }

  void _reportDog(String reportOption) {
    final dogRef =
        Firestore.instance.collection("dogs").document(widget.otherDog.id);
    try {
      Firestore.instance.runTransaction((Transaction tx) async {
        final dogSnapshot = await tx.get(dogRef);
        if (dogSnapshot.exists) {
          final Map<String, dynamic> reports =
              Map.from(dogSnapshot.data["reports"]);
          if (!reports.containsKey(widget.user)) {
            reports.addAll({widget.user: reportOption});
            print("REPORTS: $reports");
            tx.update(dogRef, {"reports": reports});
          }
        }
      });
    } catch (error) {
      print(error);
      return null;
    }
  }

  Widget _buildMessages(List<DocumentSnapshot> messages) {
    _updateMessageRead();

    return new ListView.builder(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new MessageSeparator(
              isFirstMessage: messages.length == index + 1 ? true : false,
              message: new Message(
                  user: messages[index].data["user"],
                  body: messages[index].data["body"],
                  timeStamp: messages[index].data["timeStamp"].toDate(),
                  id: messages[index].data["id"],
                  photo: messages[index].data["photo"]),
              previousMessage: messages.length != index + 1
                  ? new Message(
                      user: messages[index + 1].data["user"],
                      body: messages[index + 1].data["body"],
                      timeStamp: messages[index + 1].data["timeStamp"].toDate(),
                      id: messages[index + 1].data["id"],
                      photo: messages[index + 1].data["photo"])
                  : null,
            ),
            new MessageCell(
              context: context,
              currentDog: widget.currentDog.id,
              message: new Message(
                user: messages[index].data["user"],
                body: messages[index].data["body"],
                timeStamp: messages[index].data["timeStamp"].toDate(),
                id: messages[index].data["id"],
                photo: messages[index].data["photo"],
              ),
              nextMessage: index != 0
                  ? new Message(
                      user: messages[index - 1].data["user"],
                      body: messages[index - 1].data["body"],
                      timeStamp: messages[index - 1].data["timeStamp"].toDate(),
                      id: messages[index - 1].data["id"],
                      photo: messages[index - 1].data["photo"])
                  : null,
              previousMessage: messages.length != index + 1
                  ? new Message(
                      user: messages[index + 1].data["user"],
                      body: messages[index + 1].data["body"],
                      timeStamp: messages[index + 1].data["timeStamp"].toDate(),
                      id: messages[index + 1].data["id"],
                      photo: messages[index + 1].data["photo"],
                    )
                  : null,
            ),
          ],
        );
      },
      itemCount: messages.length,
    );
  }

  Widget _buildMessageBar() {
    return new SafeArea(
      bottom: true,
      child: new Container(
        constraints: BoxConstraints(maxHeight: 200.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.black38),
          ),
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              child: new Icon(
                Icons.photo_camera,
                color: Colors.black,
              ),
              onTap: _showPhotoOptions,
            ),
            HorizontalDivider(
              width: 8.0,
            ),
            new Expanded(
              child: new SingleChildScrollView(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    messagePhotos.isNotEmpty
                        ? new Container(
                            height: 100.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black38,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: new ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(5.0),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return new HorizontalDivider(
                                  width: 3.0,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return new GestureDetector(
                                  child: MessagePhotoCell(
                                    photo: messagePhotos[index],
                                    onPhotoDeletePressed: () {
                                      setState(() {
                                        messagePhotos.removeAt(index);
                                        _messageStatusUpdate();
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      SlideUpRoute(
                                        page: PhotoViewerPage(
                                          photo: messagePhotos[index],
                                        ),
                                      ),
                                    );
                                  }
                                );
                              },
                              itemCount: messagePhotos.length,
                            ),
                          )
                        : new Container(),
                    new TextField(
                      maxLines: null,
                      keyboardAppearance: Brightness.light,
                      controller: messageTextController,
                      cursorColor: Colors.black,
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: messagePhotos.length != 0
                              ? BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                )
                              : BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1.0,
                          ),
                          borderRadius: messagePhotos.length != 0
                              ? BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                )
                              : BorderRadius.circular(10.0),
                        ),
                        hintText: "Message ${widget.otherDog.name}...",
                        hintStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontFamily: "Proxima Nova",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            HorizontalDivider(
              width: 8.0,
            ),
            new GestureDetector(
              child: new Text(
                "Send",
                style: TextStyle(
                  color: messageReady ? Colors.black : Colors.black45,
                  fontSize: 18.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: messageReady ? _sendMessage : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesLoading() {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 30.0,
            width: 30.0,
            margin: EdgeInsets.only(bottom: 5.0),
            child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor),
            ),
          ),
          new Text(
            "Fetching Messages",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new StreamBuilder(
              stream: Firestore.instance
                  .collection("conversations")
                  .document(conversation.id)
                  .collection("messages")
                  .orderBy("timeStamp", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                return new GestureDetector(
                  child: snapshot.hasData
                      ? _buildMessages(snapshot.data.documents)
                      : _buildMessagesLoading(),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                );
              },
            ),
          ),
          _buildMessageBar(),
        ],
      ),
    );
  }
}

class MessageSeparator extends StatelessWidget {
  final bool isFirstMessage;
  final Message message;
  final Message previousMessage;

  MessageSeparator({
    this.isFirstMessage,
    this.message,
    this.previousMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isFirstMessage ||
        message.timeStamp.microsecondsSinceEpoch >
            previousMessage.timeStamp.microsecondsSinceEpoch +
                (pow(21.6, 10))) {
      return new Container(
        height: 30.0,
        alignment: Alignment.center,
        child: new Text(
          Message().convertTimeStamp(message.timeStamp),
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (message.user == previousMessage.user) {
      return new Container(
        height: 3.0,
      );
    } else {
      return new Container(
        height: 10.0,
      );
    }
  }
}
