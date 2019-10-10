import 'dart:typed_data';
import 'package:fetch/blocs/login_bloc/login_event.dart' as prefix0;
import 'package:fetch/pages/password_page.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_password_page.dart';
import 'package:fetch/blocs/sign_up_bloc/bloc.dart';
import 'package:fetch/resources/user_repository.dart';

class EmailPage extends StatefulWidget {
  final String name;
  final DateTime dateOfBirth;
  final List<Uint8List> photos;
  final String gender;
  final String breed;

  EmailPage({
    @required this.name,
    @required this.dateOfBirth,
    @required this.photos,
    @required this.gender,
    @required this.breed,
  });

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  TextEditingController emailTextController;

  final UserRepository _userRepository = new UserRepository();

  SignUpBloc _signUpBloc;

  String email;

  @override
  void initState() {
    super.initState();

    _signUpBloc = SignUpBloc(
      userRepository: _userRepository,
    );

    emailTextController = TextEditingController()..addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    emailTextController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _signUpBloc.dispatch(
      EmailChanged(
        email: emailTextController.text.toLowerCase(),
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
          text: "Next",
          disabled: !state.isEmailValid,
          onPressed: () =>
              _onEmailSubmitted(emailTextController.text.toLowerCase()),
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
            fontStyle: FontStyle.italic),
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
        controller: emailTextController,
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
              : null,
        ),
        onSubmitted: _onEmailSubmitted,
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
          "Email is already in use",
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

  void _onEmailSubmitted(String submittedEmail) {
    email = submittedEmail;

    _signUpBloc.dispatch(
      CheckIfEmailExistsPressed(email: submittedEmail.toLowerCase()),
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => new PasswordPage(
                    email: email,
                    name: widget.name,
                    dateOfBirth: widget.dateOfBirth,
                    photos: widget.photos,
                    breed: widget.breed,
                    gender: widget.gender,
                  ),
                ),
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
            },
          ),
        ),
      ),
    );
  }
}
