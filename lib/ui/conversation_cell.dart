import 'package:flutter/material.dart';
import 'package:fetch/conversation.dart';
import 'package:intl/intl.dart';
import 'package:fetch/profile.dart';

class ConversationCell extends StatefulWidget {
  @override
  _ConversationCellState createState() => _ConversationCellState();

  final Conversation conversation;
  final Profile otherDog;

  ConversationCell({
    this.conversation,
    this.otherDog,
  });
}

class _ConversationCellState extends State<ConversationCell> {
  Conversation conversation;
  String currentUser;

  @override
  void initState() {
    super.initState();
    conversation = widget.conversation;
    if (widget.otherDog != null) {
      final conversationUsers = List.from(conversation.users);
      conversationUsers.remove(widget.otherDog.id);
      currentUser = conversationUsers[0];
    }
  }

  @override
  void didUpdateWidget(ConversationCell oldWidget) {
    if (oldWidget.conversation != widget.conversation &&
        widget.otherDog != null) {
      setState(() {
        conversation = widget.conversation;
        final conversationUsers = List.from(conversation.users);
        conversationUsers.remove(widget.otherDog.id);
        currentUser = conversationUsers[0];
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 80.0,
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              new Container(
                height: 60.0,
                width: 60.0,
                decoration: widget.otherDog != null
                    ? BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.otherDog.photos[0],
                          ),
                          fit: BoxFit.cover,
                        ),
                      )
                    : BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
              ),
              widget.otherDog != null
                  ? new Container(
                      height: 15.0,
                      width: 15.0,
                      decoration: !conversation.messageRead[currentUser]
                          ? BoxDecoration(
                              color: Color.fromRGBO(0, 122, 255, 1.0),
                              border: Border.all(
                                width: 2.0,
                                color: Colors.white,
                              ),
                              shape: BoxShape.circle,
                            )
                          : BoxDecoration(color: Colors.transparent),
                    )
                  : new Container(),
            ],
          ),
          new Expanded(
            child: new Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Container(
                    child: new Text(
                      widget.otherDog != null ? widget.otherDog.name : "",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.0,
                        fontFamily: "Gotham Rounded",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  new Container(
                    child: new Text(
                      conversation.lastMessage.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0,
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
