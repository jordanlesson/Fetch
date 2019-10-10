import 'package:fetch/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fetch/pages/master_page.dart';
import 'package:fetch/pages/start_page.dart';
import 'package:fetch/pages/email_page.dart';
import 'package:fetch/pages/dog_info_page.dart';
import 'package:fetch/pages/dog_picture_page.dart';
import 'package:fetch/pages/splash_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetch/blocs/authentication_bloc/bloc.dart';
import 'simple_bloc_delegate.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() {
  Admob.initialize("ca-app-pub-7132470146221772~7776821395");
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(Fetch());
}

class Fetch extends StatefulWidget {
  @override
  _FetchState createState() => _FetchState();
}

class _FetchState extends State<Fetch> {
  final UserRepository _userRepository = UserRepository();
  
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted(
      context: context
    ));
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(0, 122, 255, 1.0),
        accentColor: Colors.black87,
        backgroundColor: Colors.white,
        cursorColor: Theme.of(context).primaryColor,
        textTheme: new TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontFamily: "Gotham Rounded",
          ),
        ),
      ),
      //initialRoute: "/StartPage",
      home: new BlocProvider(
        bloc: _authenticationBloc,
        child: MaterialApp(
          home: new BlocBuilder(
            bloc: _authenticationBloc,
            builder: (BuildContext context, AuthenticationState state) {
              if (state is Uninitialized) {
                print("UNINITIALIZED");
                return SplashPage();
              }
              if (state is Unauthenticated) {
                print("UNAUTHENTICATED");
                return StartPage();
              }
              if (state is Authenticated) {
                print("AUTHENTICATED");
                return HomePage(
                  onboarding: false,
                  user: state.user,
                );
              }
            },
          ),
        ),
      ),
      routes: {
        "/StartPage": (BuildContext context) => new StartPage(),
        "/EmailPage": (BuildContext context) => new EmailPage(),
        "/DogInfoPage": (BuildContext context) => new DogInfoPage(),
      },
    );
  }
}
