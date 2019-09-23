import 'dart:typed_data';

import 'package:fetch/blocs/sign_up_bloc/bloc.dart';
import 'package:fetch/resources/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:fetch/ui/tab_bar_item.dart';
import 'package:fetch/ui/dog_info_title.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'email_page.dart';
import 'dog_breed_page.dart';
import 'package:fetch/transitions.dart';

class DogGenderPage extends StatefulWidget {
  final String name;
  final DateTime dateOfBirth;
  final List<Uint8List> photos;

  DogGenderPage(
      {@required this.name, @required this.dateOfBirth, @required this.photos});

  @override
  _DogGenderPageState createState() => _DogGenderPageState();
}

class _DogGenderPageState extends State<DogGenderPage> {
  String gender;
  TextEditingController breedTextController;

  final UserRepository _userRepository = new UserRepository();

  SignUpBloc _signUpBloc;

  @override
  void initState() {
    super.initState();
    breedTextController = TextEditingController();

    _signUpBloc = SignUpBloc(
      userRepository: _userRepository,
    );
  }

  @override
  void dispose() { 
    _signUpBloc.dispose();
    breedTextController.dispose();
    super.dispose();
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
          disabled: !(state.isGenderValid && state.isBreedValid) || state.isSubmitting,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => new EmailPage(
                  name: widget.name,
                  dateOfBirth: widget.dateOfBirth,
                  photos: widget.photos,
                  gender: gender,
                  breed: breedTextController.text,
                ),
              ),
            );
          },
        ),
      ],
      elevation: 0.0,
    );
  }

  Widget _buildGenderOption() {
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
            child: DogGenderButton.male(
              enabled: gender == "male" ? true : false,
              onPressed: () {
                setState(() {
                  gender = "male";
                  _signUpBloc.dispatch(
                    GenderChanged(
                      gender: gender,
                    ),
                  );
                });
              },
            ),
          ),
          new Container(
            color: Colors.black12,
            width: 0.5,
            height: 50.0,
          ),
          new Expanded(
            child: new DogGenderButton.female(
              enabled: gender == "female" ? true : false,
              onPressed: () {
                setState(() {
                  gender = "female";
                  _signUpBloc.dispatch(
                    GenderChanged(
                      gender: gender,
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreedInput() {
    return new Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      constraints: BoxConstraints(maxWidth: 350.0),
      child: new TextField(
        autocorrect: false,
        controller: breedTextController,
        textAlign: breedTextController.text.isNotEmpty
            ? TextAlign.center
            : TextAlign.start,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: Color.fromRGBO(240, 240, 240, 1.0),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: "Breed",
          hintStyle: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w400),
        ),
        onTap: _selectDogBreed,
      ),
    );
  }

  void _selectDogBreed() {
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context)
        .push(
          SlideUpRoute(
            page: new WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: new DogBreedPage(),
            ),
          ),
        )
        .then(_onBreedSelected);
  }

  void _onBreedSelected(dynamic breed) {
    if (breed != null) {
      setState(() {
        breedTextController.text = breed;

        _signUpBloc.dispatch(
          BreedChanged(
            breed: breed,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new BlocProvider(
      bloc: _signUpBloc,
      child: new BlocBuilder(
          bloc: _signUpBloc,
          builder: (BuildContext context, SignUpState state) {
            return new Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: _buildAppBar(state),
              body: new FractionallySizedBox(
                heightFactor: 1 / 2,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DogInfoTitle(
                      title: "Select Your Dog's Gender",
                    ),
                    _buildGenderOption(),
                    DogInfoTitle(
                      title: "Select Your Dog's Breed",
                    ),
                    _buildBreedInput(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class DogGenderButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool enabled;
  final Color color;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;

  DogGenderButton.male({@required this.enabled, this.onPressed})
      : text = "Good Boy",
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        icon = IconData(0xe900, fontFamily: "gender_male"),
        color = Colors.blue;

  DogGenderButton.female({@required this.enabled, this.onPressed})
      : text = "Good Girl",
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        icon = IconData(0xe900, fontFamily: "gender_female"),
        color = Colors.pink[300];

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: enabled ? color : Colors.transparent,
            borderRadius: borderRadius),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(right: 5.0),
              child: new Icon(
                icon,
                color: enabled ? Colors.white : color,
              ),
            ),
            new Text(
              text,
              style: TextStyle(
                color: enabled ? Colors.white : color,
                fontSize: 20.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
