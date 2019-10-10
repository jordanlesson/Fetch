import 'package:fetch/ui/profile_info_input.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/hotmail.dart';
import 'package:mailer/smtp_server/yahoo.dart';

class BugsPage extends StatefulWidget {

  final FirebaseUser user;

  BugsPage({@required this.user});

  @override
  _BugsPageState createState() => _BugsPageState();
}

class _BugsPageState extends State<BugsPage> {

  String _bug;

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        "Report a Bug",
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Proxima Nova",
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: new BackButton(
        color: Colors.black,
      ),
      actions: <Widget>[
        TextActionButton(
          color: Color.fromRGBO(0, 122, 255, 1.0),
          text: "Report",
          disabled: _bug == null || _bug.isEmpty,
          onPressed: _sendBug,
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

  void _sendBug() async {
    Navigator.of(context).pop();

  final smtpServer = gmail("jordantreylesson@gmail.com", "9Manatee");
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.  
  
  // Create our message.
  final message = Message()
    ..from = Address("jordantreylesson@gmail.com", 'Fetch Bug ${widget.user.uid}')
    ..recipients.add('jordantreylesson@gmail.com')
    // ..ccRecipients.addAll([])
    // ..bccRecipients.add(Address(''))
    ..subject = 'Fetch Bug ${DateTime.now()}'
    ..text = _bug;
    //..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print(sendReport.mail);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    print(e);
    print(e.problems);
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
  }

  void _onBugChanged(String bug) {
    setState(() {
      _bug = bug;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: _buildAppBar(),
      body: new Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ProfileInfoInput(
              initialText: "",
              hintText: "Describe the bug in detail",
              labelText: "",
              maxHeight: 350.0,
              maxLength: 500,
              maxLines: null,
              autoFocus: true,
              onTextChanged: _onBugChanged,
            ),
          ),
          new Container(
            constraints: BoxConstraints(
              maxWidth: 350.0,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: new Text(
              "In order to improve your experience on Fetch, please report any bugs or disturbances you encounter",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}