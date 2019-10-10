import 'package:flutter/material.dart';
import 'package:fetch/models/store_item.dart';

class StoreItemCell extends StatelessWidget {

  final StoreItem storeItem;
  
  StoreItemCell({
    @required this.storeItem,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.0,
            color: Theme.of(context).primaryColor.withOpacity(0.12),
          ),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              color: Colors.black12,
              offset: Offset(0.0, 5.0),
              spreadRadius: 0.0,
            ),
          ]),
      child: new Column(
        children: <Widget>[
          new Expanded(
            child: new Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: new Container(
                    padding: EdgeInsets.all(3.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10.0),
                      image: new DecorationImage(
                        image: AssetImage(
                          storeItem.photos.first,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(3.0),
                  child: new Container(
                      height: 35.0,
                      width: 35.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5.0,
                            color: Colors.black54,
                            offset: Offset(0.0, 5.0),
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: new Text(
                        "\$${storeItem.price.toInt()}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: "Proxima Nova",
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              // border: Border(
              //   top: BorderSide(
              //     color: Colors.black12,
              //     width: 1.0,
              //   ),
              // ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: new Text(
              storeItem.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}