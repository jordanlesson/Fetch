import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MemesPage extends StatefulWidget {
  final FirebaseUser user;

  MemesPage({@required this.user});

  @override
  _MemesPageState createState() => _MemesPageState();
}

class _MemesPageState extends State<MemesPage> {
  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Icon(
        Icons.card_membership,
        color: Colors.black,
      ),
      centerTitle: true,
      leading: new BackButton(
        color: Colors.black,
      ),
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
    );
  }
}
