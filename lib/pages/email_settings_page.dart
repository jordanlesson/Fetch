import 'package:fetch/ui/text_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailSettingsPage extends StatefulWidget {
  @override
  _EmailSettingsPageState createState() => _EmailSettingsPageState();
}

class _EmailSettingsPageState extends State<EmailSettingsPage> {
  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        "Email",
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
          color: Color.fromRGBO(0, 122, 255, 1.0),
          text: "Done",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      bottom: PreferredSize(
        child: new Container(
          color: Colors.black12,
          height: 1.0,
        ),
        preferredSize: Size.fromHeight(1.0),
      ),
      elevation: 0.0,
    );
  }

  Widget _buildEmailTextField() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: new Text(
            "EMAIL",
            style: TextStyle(
              color: Color.fromRGBO(80, 80, 80, 1.0),
              fontSize: 14.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        new Container(
          height: 50.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                width: 1.0,
                color: Colors.black12,
              ),
              bottom: BorderSide(
                width: 1.0,
                color: Colors.black12,
              ),
            ),
          ),
          child: new TextField(

          ),
        ),
      ],
    );
  }

  Widget _buildChangeEmailButton() {
    return new GestureDetector(
      child: new Container(
        height: 50.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              width: 1.0,
              color: Colors.black12,
            ),
            bottom: BorderSide(
              width: 1.0,
              color: Colors.black12,
            ),
          ),
        ),
        child: new Text(
          "Change Email",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 17.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: _buildAppBar(),
      body: new FractionallySizedBox(
        heightFactor: 0.5,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildEmailTextField(),
            _buildChangeEmailButton(),
          ],
        ),
      ),
    );
  }
}
