import 'package:fetch/ui/login_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../transitions.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController pageController;
  int _currentPage;

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
    _currentPage = 0;
  }

  Widget _buildFirstOnboardingPage() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Expanded(
            flex: 3,
            child: new Container(
              alignment: Alignment.center,
              child: new Text(
                "Discover cute and lovable dogs",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          new Expanded(
            flex: 7,
            child: new Center(
              child: new Container(
                height: 275.0,
                width: 200.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1.0,
                    color: Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    new BoxShadow(
                      color: Color(0x11000000),
                      offset: Offset(0.0, 5.0),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/dog_photo_1.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondOnboardingPage() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Expanded(
            flex: 3,
            child: new Container(
              alignment: Alignment.center,
              child: new Text(
                "Swipe right to like a dog or swipe left to pass",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          new Expanded(
            flex: 7,
            child: new Center(
              child: new Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  new Container(
                    height: 275.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(
                        width: 1.0,
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x11000000),
                          offset: Offset(0.0, 5.0),
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                  new Transform.rotate(
                    angle: math.pi / 12,
                    child: new Container(
                      height: 275.0,
                      width: 200.0,
                      margin: EdgeInsets.only(left: 40.0, top: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1.0,
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Color(0x11000000),
                            offset: Offset(0.0, 5.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/dog_photo_3.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: new Align(
                        alignment: Alignment.topLeft,
                        child: new Padding(
                          padding: EdgeInsets.all(16.0),
                          child: new Icon(
                            Icons.thumb_up,
                            color: Colors.green,
                            size: 75.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdOnboardingPage() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Expanded(
            flex: 3,
            child: new Container(
              alignment: Alignment.center,
              child: new Text(
                "Really like a dog? Swipe up to treat a dog",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          new Expanded(
            flex: 7,
            child: new Center(
              child: new Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    width: 175.0,
                    margin: EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(
                        width: 1.0,
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x11000000),
                          offset: Offset(0.0, 5.0),
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                  new Align(
                    alignment: Alignment.topCenter,
                    child: new Container(
                      height: 275.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1.0,
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Color(0x11000000),
                            offset: Offset(0.0, 5.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/dog_photo_2.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: new Align(
                        alignment: Alignment.bottomCenter,
                        child: new Padding(
                          padding: EdgeInsets.all(16.0),
                          child: new Icon(
                            IconData(0xe900, fontFamily: "treat"),
                            color: Theme.of(context).primaryColor,
                            size: 75.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFourthOnboardingPage() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Expanded(
            flex: 3,
            child: new Container(
              alignment: Alignment.center,
              child: new Text(
                "Connect with other dog owners",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          new Expanded(
            flex: 7,
            child: new Center(
              child: new Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                constraints: BoxConstraints(maxWidth: 350.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1.0,
                    color: Colors.black12,
                  ),
                  boxShadow: [
                    new BoxShadow(
                      color: Color(0x11000000),
                      offset: Offset(0.0, 5.0),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: new Column(
                  children: <Widget>[
                    new Container(
                      height: 50.0,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            height: 30.0,
                            width: 30.0,
                            margin: EdgeInsets.only(right: 3.0),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/dog_photo_0.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          new Text(
                            "Biscuit",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontFamily: "Proxima Nova",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints contraints) {
                            return new Column(
                              children: <Widget>[
                                new Align(
                                  alignment: Alignment.topRight,
                                  child: new Container(
                                    padding: EdgeInsets.all(8.0),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          (contraints.maxWidth / 2) + 50.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                    ),
                                    child: new Text(
                                      "OMG your dog is adorable! How do you cut its fur?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontFamily: "Proxima Nova",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                new Divider(
                                    height: 10.0, color: Colors.transparent),
                                new Align(
                                  alignment: Alignment.topLeft,
                                  child: new Container(
                                    padding: EdgeInsets.all(8.0),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          (contraints.maxWidth / 2) + 50.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(229, 229, 234, 1.0),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    child: new Text(
                                      "Thank you so much! I take him to a special groomer",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontFamily: "Proxima Nova",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                new Divider(
                                  color: Colors.transparent,
                                  height: 10.0,
                                ),
                                new Align(
                                  alignment: Alignment.topRight,
                                  child: new Container(
                                    padding: EdgeInsets.all(8.0),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          (contraints.maxWidth / 2) + 50.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                    ),
                                    child: new Text(
                                      "We should get our dogs together to play!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontFamily: "Proxima Nova",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new PageIndicator(
        currentIndex: _currentPage,
        numberOfPages: 4,
      ),
    );
  }

  Widget _buildBeginSwipingButton() {
    return new Expanded(
      child: new Container(
        alignment: Alignment.center,
        child: new LoginButton(
          text: "BEGIN SWIPING",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _buildLegalNotice() {
    return new SafeArea(
      top: false,
      bottom: true,
      child: new Container(
        padding: EdgeInsets.all(8.0),
        child: new RichText(
          //'By clicking "BEGIN SWIPING" you agree to Fetch\'s Term and Service and Privacy Policy',
          text: new TextSpan(
            children: [
              TextSpan(
                text: 'By clicking "BEGIN SWIPING" you agree to Fetch\'s ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: "Terms and Services",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () async {
                    const url =
                        'https://app.termly.io/document/terms-of-use-for-website/759dbddd-085e-44c7-8c32-45afa2b26a9c';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
              ),
              TextSpan(
                text: ' and ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: "Privacy Policy",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () async {
                    const url =
                        'https://app.termly.io/document/privacy-policy/d25d7f6f-c09b-4122-9634-844b21e343df';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          new Expanded(
            flex: 7,
            child: new Container(
              alignment: Alignment.topCenter,
              child: new PageView(
                controller: pageController,
                onPageChanged: _onPageChanged,
                children: <Widget>[
                  _buildFirstOnboardingPage(),
                  _buildSecondOnboardingPage(),
                  _buildThirdOnboardingPage(),
                  _buildFourthOnboardingPage(),
                ],
              ),
            ),
          ),
          new Expanded(
            flex: 3,
            child: new Container(
              child: new Column(
                children: <Widget>[
                  _buildPageIndicator(),
                  _buildBeginSwipingButton(),
                  _buildLegalNotice(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatefulWidget {
  final int numberOfPages;
  final int currentIndex;

  PageIndicator({@required this.numberOfPages, @required this.currentIndex});

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        widget.numberOfPages,
        (index) {
          return PageIndicatorCircle(
            isActive: index == widget.currentIndex,
          );
        },
      ),
    );
  }
}

class PageIndicatorCircle extends StatelessWidget {
  final bool isActive;

  PageIndicatorCircle({this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.black12,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}
