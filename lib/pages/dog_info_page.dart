import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:fetch/ui/dog_info_title.dart';
import 'dog_picture_page.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fetch/transitions.dart';
import 'package:fetch/blocs/sign_up_bloc/bloc.dart';
import 'package:fetch/resources/user_repository.dart';

class DogInfoPage extends StatefulWidget {
  @override
  _DogInfoPageState createState() => _DogInfoPageState();
}

class _DogInfoPageState extends State<DogInfoPage> {
  TextEditingController nameTextController;
  TextEditingController birthdayTextController;

  SignUpBloc _signUpBloc;

  final UserRepository _userRepository = new UserRepository();

  bool dogInfoIsValid;
  bool dogNameIsValid;
  bool dogBirthdayIsValid;

  DateTime dateOfBirth;

  @override
  void initState() {
    super.initState();

    dogInfoIsValid = false;

    nameTextController = TextEditingController()..addListener(_onNameChanged);

    birthdayTextController = TextEditingController()
      ..addListener(_onDateOfBirthChanged);

    _signUpBloc = SignUpBloc(
      userRepository: _userRepository,
    );
  }

  @override
  void dispose() { 
    _signUpBloc.dispose();
    nameTextController.dispose();
    birthdayTextController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    _signUpBloc.dispatch(
      NameChanged(
        name: nameTextController.text,
      ),
    );
  }

  void _onDateOfBirthChanged() {
    _signUpBloc.dispatch(
      DateOfBirthChanged(
        dateOfBirth: dateOfBirth,
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
          disabled: !(state.isDogNameValid && state.isDogDateOfBirthValid),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => DogPicturePage(
                  name: nameTextController.text,
                  dateOfBirth: dateOfBirth,
                ),
              ),
            );
          },
        ),
      ],
      elevation: 0.0,
    );
  }

  Widget _buildDogNameInput() {
    return new Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      constraints: BoxConstraints(maxWidth: 350.0),
      child: new TextField(
        autocorrect: false,
        autofocus: true,
        controller: nameTextController,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          fillColor: Color.fromRGBO(240, 240, 240, 1.0),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: "Dog's Name",
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w400,
          ),
        ),
        maxLength: 16,
        maxLengthEnforced: true,
        buildCounter: (BuildContext context,
            {int currentLength, int maxLength, bool isFocused}) {
          return new Container();
        },
        textInputAction: TextInputAction.next,
        onSubmitted: (text) => _selectDogBirthday(),
      ),
    );
  }

  Widget _buildDogBirthday() {
    return new Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      constraints: BoxConstraints(maxWidth: 350.0),
      child: new TextField(
        autocorrect: false,
        controller: birthdayTextController,
        textAlign: birthdayTextController.text.isNotEmpty
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
          hintText: "Dog's Date of Birth",
          hintStyle: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w400),
        ),
        onTap: _selectDogBirthday,
      ),
    );
  }

  void _selectDogBirthday() async {
    FocusScope.of(context).requestFocus(FocusNode());

    await Future.delayed(Duration(milliseconds: 500), () {
      DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: DateTime.now().subtract(Duration(days: 10950)),
        maxTime: DateTime.now(),
        onConfirm: (date) {
          setState(() {
            dateOfBirth = date;

            birthdayTextController.text = DateFormat("MM/dd/yyyy").format(date);
          });
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en,
        theme: DatePickerTheme(
          backgroundColor: Colors.white,
          itemStyle: TextStyle(
            color: Colors.black87,
            fontFamily: "Proxima Nova",
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
          doneStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: "Proxima Nova",
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
          cancelStyle: TextStyle(
            color: Colors.black54,
            fontFamily: "Proxima Nova",
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new BlocProvider(
      bloc: _signUpBloc,
      child: new BlocListener(
        bloc: _signUpBloc,
        listener: (BuildContext context, SignUpState state) {

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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DogInfoTitle(
                      title: "Enter Your Dog's Name",
                    ),
                    _buildDogNameInput(),
                    DogInfoTitle(
                      title: "Enter Your Dog's Date of Birth",
                    ),
                    _buildDogBirthday(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
