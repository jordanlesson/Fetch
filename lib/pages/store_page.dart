import 'package:fetch/models/store_item.dart';
import 'package:fetch/pages/store_item_details_page.dart';
import 'package:fetch/transitions.dart';
import 'package:fetch/ui/store_item_cell.dart';
import 'package:fetch/ui/tab_bar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  final FirebaseUser user;

  StorePage({@required this.user});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  String _storeFilter;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _storeFilter = "Best Match";
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Icon(
        Icons.local_grocery_store,
        color: Colors.black,
      ),
      centerTitle: true,
      leading: new BackButton(
        color: Colors.black,
      ),
      elevation: 0.0,
      bottom: new PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 1.0,
              ),
            ),
          ),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                child: new TabBarItem(
                  text: "Store",
                  color:
                      true ? Color.fromRGBO(0, 122, 255, 1.0) : Colors.black38,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      // tabBarIndex = 0;
                    });
                  },
                ),
              ),
              new Container(
                width: 1.0,
                height: 30.0,
                color: Colors.black12,
                margin: EdgeInsets.symmetric(vertical: 5.0),
              ),
              new Expanded(
                child: new TabBarItem(
                  text: "History",
                  color:
                      false ? Color.fromRGBO(0, 122, 255, 1.0) : Colors.black38,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      // tabBarIndex = 1;
                    });
                  },
                ),
              ),
              new Container(
                width: 1.0,
                height: 30.0,
                color: Colors.black12,
                margin: EdgeInsets.symmetric(vertical: 5.0),
              ),
              new Expanded(
                child: new TabBarItem(
                  text: "Cart",
                  color:
                      false ? Color.fromRGBO(0, 122, 255, 1.0) : Colors.black38,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      // tabBarIndex = 1;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterMenu() {
    return new Drawer(
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            "Filter",
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
          bottom: PreferredSize(
            child: new Container(
              color: Colors.black12,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0),
          ),
          elevation: 0.0,
        ),
        body: new Container(
          color: Color.fromRGBO(245, 245, 245, 1.0),
          alignment: Alignment.center,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FilterMenuButton(
                filterLabel: "Best Match",
                selected: _storeFilter == "Best Match",
                onPressed: () => _onFilterSelected("Best Match"),
              ),
              FilterMenuButton(
                filterLabel: "Price: Low to High",
                selected: _storeFilter == "Price: Low to High",
                onPressed: () => _onFilterSelected("Price: Low to High"),
              ),
              FilterMenuButton(
                filterLabel: "Price: High to Low",
                selected: _storeFilter == "Price: High to Low",
                onPressed: () => _onFilterSelected("Price: High to Low"),
              ),
              FilterMenuButton(
                filterLabel: "Best Selling",
                selected: _storeFilter == "Best Selling",
                onPressed: () => _onFilterSelected("Best Selling"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFilterSelected(String filter) {
    if (_storeFilter != filter) {
      setState(() {
        _storeFilter = filter;
      });
    }
  }

  Widget _buildStoreItemGrid() {
    return new GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.0 / 4.0,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
            child: new Hero(
              tag: index,
              child: new StoreItemCell(
                storeItem: demoStoreItems[index],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                SlideUpRoute(
                  page: StoreItemDetailsPage(
                    storeItem: demoStoreItems[index],
                  ),
                ),
              );
            });
      },
      itemCount: 10,
    );
  }

  Widget _buildFilterBar() {
    return new Container(
      height: 30.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.bottomLeft,
      child: new GestureDetector(
        child: new Row(
          children: <Widget>[
            new Icon(
              Icons.sort,
              color: Theme.of(context).primaryColor,
            ),
            new Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              child: new Text(
                "FILTER",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          _scaffoldKey.currentState.openEndDrawer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      endDrawer: _buildFilterMenu(),
      appBar: _buildAppBar(),
      body: new ListView(
        children: <Widget>[
          _buildFilterBar(),
          _buildStoreItemGrid(),
        ],
      ),
    );
  }
}

class FilterMenuButton extends StatelessWidget {
  final String filterLabel;
  final bool selected;
  final VoidCallback onPressed;

  FilterMenuButton({
    @required this.filterLabel,
    @required this.selected,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              width: 1.0,
              color: Colors.black12,
            ),
          ),
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              filterLabel,
              style: TextStyle(
                color: selected ? Theme.of(context).primaryColor : Colors.black,
                fontSize: 14.0,
                fontFamily: "Proxima Nova",
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
            selected
                ? new Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                  )
                : new Container(),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
