import 'package:flutter/material.dart';
import 'package:fetch/ui/text_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:fetch/ui/check_circle.dart';
import 'package:fetch/utils/breeds.dart';

class DogBreedPage extends StatefulWidget {
  @override
  _DogBreedPageState createState() => _DogBreedPageState();
}

class _DogBreedPageState extends State<DogBreedPage> {
  TextEditingController breedTextController;
  List<String> breedQuery;

  @override
  void initState() {
    super.initState();

    breedQuery = new List();

    breedTextController = TextEditingController()
      ..addListener(() {
        setState(() {
          breedQuery = breeds
              .where((breed) => breed.startsWith(breedTextController.text))
              .toList();
        });
      });
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        "Select a Breed",
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
      elevation: 0.0,
    );
  }

  Widget _buildSearchBar() {
    return new Container(
      height: 60.0,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.black12,
          ),
        ),
      ),
      child: new CupertinoTextField(
        autocorrect: false,
        autofocus: true,
        controller: breedTextController,
        clearButtonMode: OverlayVisibilityMode.never,
        textInputAction: TextInputAction.search,
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
        prefix: new Container(
          margin: EdgeInsets.only(left: 8.0),
          child: new Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
            size: 20.0,
          ),
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        placeholder: "Search for Breed",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 17.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w400,
        ),
        textCapitalization: TextCapitalization.words,
      ),
    );
  }

  Widget _buildSearchResults() {
    return breedQuery.isNotEmpty
        ? new ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return new Container(
                height: 1.0,
                color: Colors.black12,
                margin: EdgeInsets.only(left: 16.0),
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector(
                child: new SearchResultCell(
                  result: breedQuery[index],
                ),
                onTap: () {
                  Navigator.of(context).pop(breedQuery[index]);
                },
              );
            },
            itemCount: breedQuery.length,
          )
        : new Center(
            child: new Text(
              "No Matching Dog Breeds",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: _buildAppBar(),
      body: new Column(
        children: <Widget>[
          _buildSearchBar(),
          new Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }
}

class SearchResultCell extends StatelessWidget {
  final String result;

  SearchResultCell({this.result});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50.0,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: new Text(
        result,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
