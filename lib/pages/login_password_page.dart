import 'package:fetch/blocs/login_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dog_info_page.dart';
import 'package:fetch/transitions.dart';
import 'home_page.dart';
import 'master_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:fetch/blocs/login_bloc/login_bloc.dart';

import 'onboarding_page.dart';

class LoginPasswordPage extends StatefulWidget {
  final String email;

  LoginPasswordPage({this.email});

  @override
  _LoginPasswordPageState createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends State<LoginPasswordPage> {
  TextEditingController _passwordTextController;

  final UserRepository _userRepository = UserRepository();

  LoginBloc _loginBloc;

  bool _isHidden;

  @override
  void initState() {
    super.initState();

    _loginBloc = LoginBloc(
      userRepository: _userRepository,
    );

    _passwordTextController = TextEditingController()
      ..addListener(_onPasswordChanged);

    _isHidden = true;
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    _loginBloc.dispatch(
      PasswordChanged(
        password: _passwordTextController.text,
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
          text: "Login",
          disabled: !state.isPasswordValid,
          onPressed: () => _onPasswordSubmitted(),
        ),
      ],
      elevation: 0.0,
    );
  }

  void _onLoginCanceled() {
    FocusScope.of(context).requestFocus(FocusNode());

    Future.delayed(
      Duration(milliseconds: 200),
      () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildTitle() {
    return new Container(
      alignment: Alignment.center,
      child: new Text(
        "Enter your Password",
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
          "Invalid Password",
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
        controller: _passwordTextController,
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
              : new GestureDetector(
                  child: new Icon(
                    _isHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black87,
                    // size: 18.0,
                  ),
                  onTap: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                ),
        ),
        onSubmitted: (text) => _onPasswordSubmitted(),
      ),
    );
  }

  void _onPasswordSubmitted() {
    _loginBloc.dispatch(
      LoginWithCredentialsPressed(
        email: widget.email,
        password: _passwordTextController.text,
        context: context
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
              Navigator.of(context).pushAndRemoveUntil(
                SlideUpRoute(
                  page: new WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: new HomePage(
                      user: state.user,
                      onboarding: false,
                    ),
                  ),
                ),
                (route) => route.isFirst
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
            },
          ),
        ),
      ),
    );
  }
}
