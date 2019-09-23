import 'package:fetch/pages/dog_info_page.dart';
import 'package:fetch/transitions.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:flutter/material.dart';

import 'dog_gender_page.dart';
import 'email_page.dart';

class OwnerAccountPage extends StatefulWidget {
  @override
  _OwnerAccountPageState createState() => _OwnerAccountPageState();
}

class _OwnerAccountPageState extends State<OwnerAccountPage> {

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.transparent,
      title: new Icon(
        IconData(0xe900, fontFamily: "fetch"),
        color: Theme.of(context).primaryColor,
      ),
      centerTitle: true,
      leading: new BackButton(
        color: Theme.of(context).primaryColor,
      ),
      elevation: 0.0,
    );
  }

  Widget _buildTitle() {
    return new Container(
      alignment: Alignment.center,
      child: new Text(
        "Do You Own a Dog?",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 30.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildError() {
    return new SnackBar(
      backgroundColor: Colors.red,
      content: new Container(
        height: 30.0,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
        child: new Text(
          "Invalid Email",
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

  Widget _buildOptions() {
    return new Container(
      height: 75.0,
      margin: EdgeInsets.symmetric(horizontal: 40.0),
      constraints: BoxConstraints(maxWidth: 350.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 240, 240, 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new OptionButton.yes(
              onPressed: () {
                Navigator.of(context).push(
                  SlideLeftRoute(
                    page: DogInfoPage(),
                  ),
                );
              },
            ),
            
          ),
          new Container(
            color: Colors.black12,
            width: 0.5,
            height: 50.0,
          ),
          new Expanded(
            child: new OptionButton.no(
              onPressed: () {
                Navigator.of(context).push(
                  SlideLeftRoute(
                    page: EmailPage(
                      breed: null,
                      gender: null,
                      photos: null,
                      dateOfBirth: null,
                      name: null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: new FractionallySizedBox(
        heightFactor: 1 / 2,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: _buildTitle(),
            ),
            _buildOptions(),
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;

  OptionButton.yes({@required this.onPressed})
      : text = "YES",
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        );


  OptionButton.no({@required this.onPressed})
      : text = "NO",
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        );

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: borderRadius,
            ),
        child: new Text(
              text,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
              ),
            )
     
      ),
      onTap: onPressed,
    );
  }
}
