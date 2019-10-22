import 'package:fetch/ui/dog_info_title.dart';
import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateOfBirthInfoPage extends StatefulWidget {
  @override
  _DateOfBirthInfoPageState createState() => _DateOfBirthInfoPageState();

  final DateTime dateOfBirth;

  DateOfBirthInfoPage({
    this.dateOfBirth,
  });
}

class _DateOfBirthInfoPageState extends State<DateOfBirthInfoPage> {
  DateTime dateOfBirth;
  TextEditingController birthdayTextController;

  @override
  void initState() { 
    super.initState();
  
    dateOfBirth = widget.dateOfBirth != null ? widget.dateOfBirth : DateTime.now();

    birthdayTextController = new TextEditingController();
    birthdayTextController.text = DateFormat("MM/dd/yyyy").format(dateOfBirth);

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _selectDogBirthday());
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        "Edit Date of Birth Info",
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
          disabled: dateOfBirth == null,
          onPressed: () {
            Navigator.of(context).pop(dateOfBirth);
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

  Widget _buildTitle() {
    return new Container(
      alignment: Alignment.center,
      child: new Text(
        "Enter Your Dog's Birth Date",
        style: TextStyle(
            color: Colors.black87,
            fontSize: 26.0,
            fontFamily: "Proxima Nova",
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic),
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
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      resizeToAvoidBottomPadding: true,
      body: new FractionallySizedBox(
        heightFactor: 1 / 2,
        alignment: Alignment.bottomCenter,
        child: new Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 16.0),
          padding: EdgeInsets.symmetric(vertical: 16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
            child: _buildTitle(),
            ),
            _buildDogBirthday(),
          ],
        ),
      ),
      ),
    );
  }
}