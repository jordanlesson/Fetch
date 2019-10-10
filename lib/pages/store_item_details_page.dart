import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch/models/store_item.dart';
import 'package:fetch/ui/store_photo_browser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoreItemDetailsPage extends StatefulWidget {
  final StoreItem storeItem;

  StoreItemDetailsPage({
    @required this.storeItem,
  });

  @override
  _StoreItemDetailsPageState createState() => _StoreItemDetailsPageState();
}

class _StoreItemDetailsPageState extends State<StoreItemDetailsPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Widget _buildBackButton() {
    return new SafeArea(
      top: true,
      bottom: false,
      child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return new Container(
            alignment: Alignment.centerLeft,
                      child: new GestureDetector(
                child: new Container(
                  height: 40.0,
                  width: 40.0,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 122, 255, 1.0),
                        Color.fromRGBO(0, 150, 255, 1.0),
                        Color.fromRGBO(0, 255, 200, 1.0),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 5.0),
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: new Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
                
                },
              
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoBrowser() {
    final screenSize = MediaQuery.of(context).size;

    return new Hero(
      tag: widget.storeItem.name,
      child: new Container(
        height: screenSize.height / 2.0,
        child: new StorePhotoBrowser(
          photos: widget.storeItem.photos,
          visiblePhotoIndex: 0,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return new Container(
      padding:
          EdgeInsets.only(top: 24.0, left: 16.0, right: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.black12,
          ),
        ),
      ),
      child: new Text(
        "Fetch T-Shirt Sweatshirt Hoodie",
        style: TextStyle(
          color: Colors.black.withOpacity(0.80),
          fontSize: 35.0,
          fontFamily: "Proxima Nova",
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _buildItemDetails() {
    return new Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: Colors.black12,
          ),
          bottom: BorderSide(
            width: 1.0,
            color: Colors.black12,
          ),
        ),
      ),
      child: new Column(
        children: <Widget>[
          new Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              "Item Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new Row(
              children: <Widget>[
                new Text(
                  "Sizes:",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new Row(
              children: <Widget>[
                new Text(
                  "Colors:",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          new Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "Description:",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0,),
                child: new Text(
                  widget.storeItem.description,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12.0,
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      body: new Stack(
        children: <Widget>[
          FractionallySizedBox(
            heightFactor: 0.5,
            child: new Container(
              color: Colors.white, // WHITE BACKGROUND
            ),
          ),
          new ListView(
            //shrinkWrap: true,
            children: <Widget>[
              _buildPhotoBrowser(),
              _buildTitle(),
              new Divider(
                height: 10.0,
                color: Colors.transparent,
                endIndent: 0.0,
                indent: 0.0,
                thickness: 0.0,
              ),
              _buildItemDetails(),
            ],
          ),
          _buildBackButton(),
        ],
      ),
    );
  }
}
