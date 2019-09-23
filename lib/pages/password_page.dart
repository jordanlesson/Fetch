import 'dart:typed_data';

import 'package:fetch/profile.dart';
import 'package:fetch/resources/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dog_info_page.dart';
import 'home_page.dart';
import 'package:fetch/transitions.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:fetch/blocs/sign_up_bloc/bloc.dart';

import 'master_page.dart';

class PasswordPage extends StatefulWidget {
  final String name;
  final DateTime dateOfBirth;
  final List<Uint8List> photos;
  final String gender;
  final String breed;
  final String email;

  PasswordPage({
    @required this.name,
    @required this.dateOfBirth,
    @required this.photos,
    @required this.gender,
    @required this.breed,
    @required this.email,
  });

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  TextEditingController passwordTextController;
  bool _isHidden;

  final UserRepository _userRepository = new UserRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();

  SignUpBloc _signUpBloc;

  @override
  void initState() {
    super.initState();

    _isHidden = true;

    passwordTextController = TextEditingController()
      ..addListener(_onPasswordChanged);

    _signUpBloc = SignUpBloc(
      userRepository: _userRepository,
      notificationRepository: _notificationRepository,
    );
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    _signUpBloc.dispatch(
      PasswordChanged(
        password: passwordTextController.text,
      ),
    );
  }

  Widget _buildAppBar(SignUpState state) {
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
      actions: <Widget>[
        new TextActionButton(
          color: Theme.of(context).primaryColor,
          text: "Done",
          disabled: !state.isPasswordValid,
          onPressed: () => _onPasswordSubmitted(passwordTextController.text),
        ),
      ],
      elevation: 0.0,
    );
  }

  Widget _buildTitle() {
    return new Container(
      alignment: Alignment.center,
      child: new Text(
        "Create a Password",
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

  Widget _buildTextField(SignUpState state) {
    return new Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      constraints: BoxConstraints(maxWidth: 350.0),
      child: new TextField(
        autocorrect: false,
        autofocus: true,
        controller: passwordTextController,
        obscureText: _isHidden,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          fillColor: Color.fromRGBO(240, 240, 240, 1.0),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: "Password",
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: state.isSubmitting
              ? new Container(
                  height: 8.0,
                  width: 8.0,
                  alignment: Alignment.center,
                  child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                )
              : new GestureDetector(
                  child: new Icon(
                    _isHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black87,
                  ),
                  onTap: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                ),
        ),
        onSubmitted: state.isPasswordValid ? _onPasswordSubmitted : null,
      ),
    );
  }

  void _onPasswordSubmitted(String password) {
    _signUpBloc.dispatch(
      SignUpFinished(
        context: context,
        email: widget.email,
        password: passwordTextController.text,
        dogInfo: widget.name != null
            ? new Profile(
                name: widget.name,
                dateOfBirth: widget.dateOfBirth,
                photos: widget.photos,
                gender: widget.gender,
                breed: widget.breed,
              )
            : null,
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
          "An unexpected error occurred",
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: new BlocProvider(
        bloc: _signUpBloc,
        child: new BlocListener(
          bloc: _signUpBloc,
          listener: (BuildContext context, SignUpState state) {
            if (state.isSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                SlideUpRoute(
                  page: new WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: new HomePage(
                      onboarding: true,
                      user: state.user,
                    ),
                    // new MasterPage(
                    //   user: state.user,
                    // ),
                  ),
                ),
                (route) => route.isFirst,
              );
            }
            if (state.isFailure) {
              FocusScope.of(context).requestFocus(FocusNode());

              Future.delayed(Duration(milliseconds: 200), () {
                Scaffold.of(context).showSnackBar(_buildError());
              });
            }
          },
          child: new BlocBuilder(
              bloc: _signUpBloc,
              builder: (BuildContext context, SignUpState state) {
                return new Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: _buildAppBar(state),
                  body: new FractionallySizedBox(
                    heightFactor: 1 / 2,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: _buildTitle(),
                        ),
                        _buildTextField(state),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
