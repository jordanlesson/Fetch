import 'package:fetch/message.dart';
import 'package:flutter/material.dart';
import 'messages_page.dart';
import 'package:fetch/conversation.dart';
import 'package:fetch/ui/conversation_cell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:fetch/profile.dart';

class ConversationsPage extends StatefulWidget {
  final VoidCallback previousPage;
  final FirebaseUser user;

  ConversationsPage({Key key, this.previousPage, this.user}) : super(key: key);

  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage>
    with AutomaticKeepAliveClientMixin {
  final UserRepository _userRepository = new UserRepository();
  Profile dogProfile;

  @override
  void initState() {
    super.initState();
    _fetchDogProfile();
  }

  @override
  bool get wantKeepAlive => true;

  void _fetchDogProfile() async {
    dogProfile = await _userRepository.getDogProfile(widget.user.uid);
    setState(() {});
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Icon(
        Icons.message,
        color: Colors.black,
      ),
      centerTitle: true,
      leading: new BackButton(
        color: Colors.black,
      ),
      elevation: 0.0,
    );
  }

  Widget _buildConversationList(List<DocumentSnapshot> conversations) {
    return new ListView.separated(
      padding: EdgeInsets.all(0.0),
      itemBuilder: (BuildContext context, int index) {
        final conversationUsers = List.from(conversations[index].data["users"]);
        conversationUsers.remove(dogProfile.id);
        final otherUser = conversationUsers[0].toString();

        return new FutureBuilder(
          future: _userRepository.fetchDog(otherUser),
          builder:
              (BuildContext context, AsyncSnapshot<Profile> profileSnapshot) {
            final profileHasData = profileSnapshot.hasData;
            return new GestureDetector(
              child: new ConversationCell(
                otherDog: profileHasData ? profileSnapshot.data : null,
                conversation: new Conversation(
                  id: conversations[index].data["id"],
                  users: conversations[index].data["users"],
                  messageRead: conversations[index].data["messageRead"],
                  lastMessage: new Message(
                    user: conversations[index].data["lastMessage"]["user"],
                    timeStamp: conversations[index]
                        .data["lastMessage"]["timeStamp"]
                        .toDate(),
                    body: conversations[index].data["lastMessage"]["body"],
                    id: conversations[index].data["lastMessage"]["id"],
                  ),
                ),
              ),
              onTap: () {
                if (profileSnapshot.hasData) {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) => new MessagesPage(
                  //       otherUser: profileSnapshot.data,
                  //       conversation: new Conversation(
                  //         id: snapshot.documents[index].data["id"],
                  //         users: snapshot.documents[index].data["users"],
                  //         messageRead:
                  //             snapshot.documents[index].data["messageRead"],
                  //         lastMessage: new Message(
                  //           user: snapshot.documents[index].data["lastMessage"]
                  //               ["user"],
                  //           timeStamp: snapshot.documents[index]
                  //               .data["lastMessage"]["timeStamp"].toDate(),
                  //           body: snapshot.documents[index].data["lastMessage"]
                  //               ["body"],
                  //           id: snapshot.documents[index].data["lastMessage"]
                  //               ["id"],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => new MessagesPage(
                        currentDog: dogProfile,
                        otherDog: profileSnapshot.data,
                        user: widget.user.uid,
                        conversation: new Conversation(
                          id: conversations[index].data["id"],
                          users: conversations[index].data["users"],
                          messageRead: conversations[index].data["messageRead"],
                          lastMessage: new Message(
                            user: conversations[index].data["lastMessage"]
                                ["user"],
                            timeStamp: conversations[index]
                                .data["lastMessage"]["timeStamp"]
                                .toDate(),
                            body: conversations[index].data["lastMessage"]
                                ["body"],
                            id: conversations[index].data["lastMessage"]["id"],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return new Container(
            // height: 1.0,
            // margin: EdgeInsets.only(left: 16.0),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10.0),
            //   color: Colors.black38,
            // ),
            );
      },
      itemCount: conversations.length,
    );
  }

  Widget _buildConversationFailed() {
    return new Center(
      child: new Text(
        "Failed Loading Conversations",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildConversationEmpty() {
    return new Center(
      child: new Text(
        "No Conversations Yet",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildConversationLoading() {
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
            "Fetching Conversations",
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
    super.build(context);
    return new Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: _buildAppBar(),
      body: new StreamBuilder(
        stream: dogProfile != null
            ? Firestore.instance
                .collection("conversations")
                .where("users", arrayContains: dogProfile.id)
                .snapshots()
            : Stream<QuerySnapshot>.empty(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final conversations = List<DocumentSnapshot>.from(
                snapshot.data.documents.where((conversation) =>
                    conversation.data["lastMessage"] != null));
            return conversations.isNotEmpty
                ? _buildConversationList(conversations)
                : _buildConversationEmpty();
          }
          if (snapshot.hasError) {
            return _buildConversationFailed();
          }
          if (!snapshot.hasData) {
            return dogProfile != null
                ? _buildConversationLoading()
                : _buildConversationEmpty();
          }
        },
      ),
    );
  }
}
