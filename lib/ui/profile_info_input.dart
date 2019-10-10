import 'package:flutter/material.dart';
import 'input_title.dart';

class ProfileInfoInput extends StatefulWidget {

  _ProfileInfoInputState createState() => new _ProfileInfoInputState();

  final String initialText;
  final String labelText;
  final String hintText;
  final int maxLength;
  final int maxLines;
  final double maxHeight;
  final void Function(String) onTextChanged;
  final bool autoFocus;

  ProfileInfoInput({
    this.initialText,
    this.labelText,
    this.hintText,
    this.maxLength,
    this.maxLines,
    this.maxHeight,
    this.onTextChanged,
    this.autoFocus,
  });
}

class _ProfileInfoInputState extends State<ProfileInfoInput> {

  TextEditingController textController;

  @override
  void initState() { 
    super.initState();
    textController = TextEditingController(
      text: widget.initialText,
    )..addListener(() => widget.onTextChanged(textController.text));
  }

  Widget _buildTextField() {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: new TextField(
        autofocus: widget.autoFocus != null ? widget.autoFocus : false,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        keyboardAppearance: Brightness.light,
        controller: textController,
        style: TextStyle(
          color: Colors.black.withOpacity(0.7),
          fontSize: 17.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w400,
        ),
        buildCounter: (BuildContext context,
            {int currentLength, int maxLength, bool isFocused}) {
          if (maxLength != null) {
            return new Text(
              "${(maxLength - currentLength).toString()}",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 17.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w500),
            );
          } else {
            return new Container();
          }
        },
        decoration: InputDecoration.collapsed(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: Colors.black45,
              fontSize: 17.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InputTitle(
          title: widget.labelText,
        ),
        _buildTextField(),
      ],
    );
  }
}
