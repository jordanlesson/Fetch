import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:fetch/ui/hobby_cell.dart';
import 'package:fetch/ui/check_circle.dart';
import 'package:fetch/ui/horizontal_divider.dart';
import 'package:flutter/services.dart';

class HobbyInfoPage extends StatefulWidget {
  @override
  _HobbyInfoPageState createState() => _HobbyInfoPageState();

  final String hobby;

  HobbyInfoPage({
    this.hobby,
  });
}

class _HobbyInfoPageState extends State<HobbyInfoPage> {
  int hobbyIndex;
  List<String> hobbyList;
  String hobby;

  @override
  void initState() {
    super.initState();

    hobbyList = [
      "Playing Fetch",
      "Going On Long Walks",
      "Eating Treats",
      "Napping All Day",
      "Cuddling",
      "Chasing My Tail",
      "Going To The Dog Park",
      "Riding In The Car",
      "Swimming"
    ];

    if (hobbyList.contains(widget.hobby)) {
      hobbyIndex = hobbyList.indexOf(widget.hobby);
      hobby = hobbyList[hobbyIndex];
    } else {
      hobbyIndex = 9;
      hobby = widget.hobby;
    }
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        "Edit Hobby Info",
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
          onPressed: () {
            Navigator.of(context).pop(hobby);
            print(hobby);
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

  Widget _buildListTitle() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Text(
        "HOBBIES",
        style: TextStyle(
          color: Colors.black.withOpacity(0.65),
          fontSize: 14.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildHobbyList() {
    return new Container(
      height: 500.0,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: List<Widget>.generate(
          10,
          (index) {
            return index != 9
                ? new GestureDetector(
                    child: new HobbyCell(
                      selected: hobbyIndex == index ? true : false,
                      hobby: hobbyList[index],
                    ),
                    onTap: () => _onHobbySelected(index, null),
                  )
                : HobbyInput(
                    selected: hobbyIndex == index ? true : false,
                    onPressed: _onHobbySelected,
                    hobby: hobbyIndex == 9 ? hobby : null,
                  );
          },
        ),
      ),
    );
  }

  void _onHobbySelected(int index, String customHobby) {
    setState(() {
      hobbyIndex = index;

      hobby = index != 9 ? hobbyList[hobbyIndex] : customHobby;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      resizeToAvoidBottomPadding: true,
      body: new ListView(
        children: <Widget>[
          _buildListTitle(),
          Column(
            children: List<Widget>.generate(
              10,
              (index) {
                return index != 9
                    ? new GestureDetector(
                        child: new HobbyCell(
                          selected: hobbyIndex == index ? true : false,
                          hobby: hobbyList[index],
                        ),
                        onTap: () => _onHobbySelected(index, null),
                      )
                    : HobbyInput(
                        selected: hobbyIndex == index ? true : false,
                        onPressed: _onHobbySelected,
                        hobby: hobbyIndex == 9 ? hobby : null,
                      );
              },
            ),
          ),
          // _buildHobbyList(),
        ],
      ),
    );
  }
}

class HobbyInput extends StatefulWidget {
  _HobbyInputState createState() => new _HobbyInputState();

  final bool selected;
  final void Function(int, String) onPressed;
  final String hobby;

  HobbyInput({
    this.selected,
    this.onPressed,
    this.hobby,
  });
}

class _HobbyInputState extends State<HobbyInput> {
  TextEditingController hobbyTextController;

  @override
  void initState() {
    super.initState();
    hobbyTextController = TextEditingController(text: widget.hobby)
      ..addListener(() => widget.onPressed(9, hobbyTextController.text));
  }

  @override
  void dispose() {
    hobbyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        height: 50.0,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autocorrect: true,
                controller: hobbyTextController,
                maxLengthEnforced: true,
                keyboardAppearance: Brightness.light,
                style: TextStyle(
                  color: widget.selected
                      ? Color.fromRGBO(0, 150, 255, 1.0)
                      : Colors.black,
                  fontSize: 17.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: "Add Hobby",
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 17.0,
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40)
                ],
                onTap: () => widget.onPressed(9, hobbyTextController.text),
              ),
            ),

            new HorizontalDivider(width: 8.0),
            new CheckCircle(
              checked: widget.selected,
            ),
          ],
        ),
      ),
      onTap: () => widget.onPressed(9, hobbyTextController.text),
    );
  }
}
