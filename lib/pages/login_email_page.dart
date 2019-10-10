import 'package:fetch/resources/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'login_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:fetch/resources/dog_repository.dart';
import 'package:fetch/blocs/login_bloc/bloc.dart';
import 'package:fetch/models/profile.dart';

class LoginEmailPage extends StatefulWidget {
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  TextEditingController _emailTextController;

  final UserRepository _userRepository = UserRepository();

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();

    _loginBloc = LoginBloc(
      userRepository: _userRepository,
    );

    _emailTextController = TextEditingController()
      ..addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    _emailTextController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _emailTextController.text.toLowerCase()),
    );
  }

  void _onEmailSubmitted() {
    _loginBloc.dispatch(
      CheckIfEmailExistsPressed(
        email: _emailTextController.text.toLowerCase(),
      ),
    );
  }

  Widget _buildAppBar(LoginState state) {
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
          text: "Next",
          disabled: !state.isEmailValid,
          onPressed: _onEmailSubmitted,
        ),
      ],
      elevation: 0.0,
    );
  }

  Widget _buildTitle() {
    return new Container(
      alignment: Alignment.center,
      child: new Text(
        "Enter Your Email",
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

  Widget _buildTextField(LoginState state) {
    return new Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      constraints: BoxConstraints(maxWidth: 350.0),
      child: new TextField(
        autocorrect: false,
        autofocus: true,
        controller: _emailTextController,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Color.fromRGBO(240, 240, 240, 1.0),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: "Email Address",
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: state.isLoading
              ? new Container(
                  height: 8.0,
                  width: 8.0,
                  alignment: Alignment.center,
                  child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                )
              : null,
        ),
        onSubmitted: (text) => _onEmailSubmitted(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: new BlocProvider(
        bloc: _loginBloc,
        child: new BlocListener(
          bloc: _loginBloc,
          listener: (BuildContext context, LoginState state) {
            if (state.isFailure) {
              FocusScope.of(context).requestFocus(FocusNode());

              Future.delayed(Duration(milliseconds: 200), () {
                Scaffold.of(context).showSnackBar(_buildError());
              });
            }
            if (state.isSuccess) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPasswordPage(
                    email: _emailTextController.text.toLowerCase(),
                  ),
                ),
              );
            }
          },
          child: new BlocBuilder(
              bloc: _loginBloc,
              builder: (BuildContext context, LoginState state) {
                return new Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: _buildAppBar(state),
                  body: new FractionallySizedBox(
                    heightFactor: 1 / 2,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
