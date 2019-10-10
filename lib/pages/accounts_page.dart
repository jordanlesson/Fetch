import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch/resources/dog_repository.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fetch/models/profile.dart';

class AccountsPage extends StatefulWidget {
  final FirebaseUser user;

  AccountsPage({
    @required this.user,
  });

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        "Switch Account",
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
          text: "Cancel",
          onPressed: () {
            Navigator.of(context).pop();
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

  Widget _buildAccountGrid(QuerySnapshot snapshot) {
    return new GridView.builder(
      itemBuilder: (BuildContext context, int index) {
        final accountInfo =
            index != 0 ? snapshot.documents[index - 1].data : null;

        final account = accountInfo != null
            ? new Profile(
                name: accountInfo["name"],
                dateOfBirth: accountInfo["dateOfBirth"].toDate(),
                bio: accountInfo["bio"],
                breed: accountInfo["breed"],
                photoPaths: accountInfo["photoPaths"],
                gender: accountInfo["gender"],
                hobby: accountInfo["hobby"],
                likes: accountInfo["likes"],
                treats: accountInfo["treats"],
                id: accountInfo["id"],
                owner: accountInfo["owner"],
                photos: accountInfo["photos"],
                likeCount: accountInfo["likeCount"],
                treatCount: accountInfo["treatCount"],
              )
            : null;

        return new GestureDetector(
          child: new AccountCell(
            account: account,
          ),
          onTap: () => _onAccountSelected(index != 0 ? account : "add account"),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
      ),
      itemCount: snapshot.documents.length + 1,
    );
  }

  Widget _buildLoadingText() {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 30.0,
            width: 30.0,
            margin: EdgeInsets.only(bottom: 5.0),
            child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor),
            ),
          ),
          new Text(
            "Fetching Accounts",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorText() {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 30.0,
            width: 30.0,
            margin: EdgeInsets.only(bottom: 5.0),
            child: new Icon(
              Icons.signal_wifi_off,
              color: Colors.black87,
            ),
          ),
          new Text(
            "Unable to Connect to the Internet",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _onAccountSelected(dynamic account) {
    Navigator.of(context).pop(account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      resizeToAvoidBottomPadding: true,
      body: new StreamBuilder(
          stream: Firestore.instance
              .collection("dogs")
              .where("owner", isEqualTo: widget.user.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return _buildAccountGrid(snapshot.data);
            }
            if (!snapshot.hasData) {
              return _buildLoadingText();
            }
            if (snapshot.hasError) {
              return _buildErrorText();
            }
          }),
    );
  }
}

class AccountCell extends StatelessWidget {
  final Profile account;

  AccountCell({
    @required this.account,
  });

  final DogRepository _dogRepository = new DogRepository();

  void _onDeleteOptionSelected(BuildContext context) async {
    return await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: new Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: new Text(
              "Are you sure you want to delete your dog profile?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                wordSpacing: 0.1,
                height: 1.25,
              ),
            ),
          ),
          content: new Text(
            "You will not be able to recover your dog's profile once deleted",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontFamily: "Proxima Nova",
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            new GestureDetector(
              child: Material(
                type: MaterialType.transparency,
                child: new Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        width: 1.0,
                        color: Colors.black12,
                      ),
                      right: BorderSide(
                        width: 0.5,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  child: new Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      fontFamily: "Proxima Nova",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            new GestureDetector(
              child: new Material(
                type: MaterialType.transparency,
                child: new Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        width: 1.0,
                        color: Colors.black12,
                      ),
                      left: BorderSide(
                        width: 0.5,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  child: new Text(
                    "Delete",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontFamily: "Proxima Nova",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop("delete");
              },
            ),
          ],
        );
      },
    ).then((delete) async {
      if (delete != null) {
        _dogRepository.deleteDogProfile(account);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.black12,
      padding: EdgeInsets.fromLTRB(0.5, 0.0, 0.5, 1.0),
      child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return new Container(
            color: Colors.white,
            child: new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    account != null
                        ? new Container(
                            height: constraints.maxHeight / 2,
                            width: constraints.maxWidth / 2,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  account.photos.first,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ))
                        : new Container(
                            height: constraints.maxHeight / 2,
                            width: constraints.maxWidth / 2,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: new Icon(
                              Icons.add,
                              color: Colors.white,
                              size: constraints.maxWidth / 4,
                            )),
                    new Container(
                      padding: EdgeInsets.all(8.0),
                      child: new Text(
                        account != null
                            ? "${account.name}, ${Profile().convertDate(account.dateOfBirth)}"
                            : "Add Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: "Gotham Rounded",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                account != null ? new Align(
                  alignment: Alignment.topRight,
                  child: new GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: new Icon(
                        Icons.do_not_disturb_on,
                        color: Colors.red.withOpacity(0.90),
                      ),
                    ),
                    onTap: () => _onDeleteOptionSelected(context),
                  ),
                ) : new Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
