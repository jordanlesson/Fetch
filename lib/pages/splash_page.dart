import 'package:fetch/pages/home_page.dart';
import 'package:fetch/pages/master_page.dart';
import 'package:fetch/pages/start_page.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:fetch/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
    body: Center(
      child: new Container(
        height: 150.0,
        width: 150.0,
        color: Colors.white,
        child: new Image.asset(
          "assets/fetch_splash.png",
          alignment: Alignment.center,
          fit: BoxFit.cover,
        ),
      ),
    )
    );
  }
}
