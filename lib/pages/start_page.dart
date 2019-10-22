import 'package:fetch/pages/onboarding_page.dart';
import 'package:fetch/pages/owner_account_page.dart';
import 'package:fetch/ui/gradient_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:fetch/ui/login_button.dart';
import 'package:fetch/transitions.dart';
import 'dog_info_page.dart';
import 'home_page.dart';
import 'login_email_page.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  int _backImageIndex;
  int _frontImageIndex;
  AnimationController imageAnimationController;
  Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();

    _backImageIndex = 1;
    _frontImageIndex = 0;

    imageAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _frontImageIndex = _backImageIndex;

            imageAnimationController.reset();

            Future.delayed(Duration(seconds: 3), () {
              setState(() {
                _backImageIndex =
                    _backImageIndex != 4 ? _backImageIndex + 1 : 0;
              });
            });

            Future.delayed(
                Duration(seconds: 5), () => imageAnimationController.forward());
          });
        }
      });

    _imageAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(imageAnimationController);

    Future.delayed(
        Duration(seconds: 5), () => imageAnimationController.forward());
  }

  @override
  void dispose() {
    imageAnimationController.dispose();
    super.dispose();
  }

  Widget _buildBackImage() {
    return new Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image:
              AssetImage("assets/dog_photo_${_backImageIndex.toString()}.jpg"),
        ),
      ),
    );
  }

  Widget _buildFrontImage() {
    return new FadeTransition(
      opacity: _imageAnimation,
      child: new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
                "assets/dog_photo_${_frontImageIndex.toString()}.jpg"),
          ),
        ),
      ),
    );
  }

  Widget _buildFetchLogo() {
    return new SafeArea(
      top: true,
      bottom: false,
    child: new Container(
      height: 50.0,
      alignment: Alignment.topCenter,
      child: 
      // ShaderMask(
      //   shaderCallback: (Rect bounds) {
      //     return LinearGradient(
      //       colors: [
      //         Color.fromRGBO(0, 122, 255, 1.0),
      //         Color.fromRGBO(0, 255, 230, 1.0),
      //       ],
      //       begin: Alignment.centerLeft,
      //       end: Alignment.centerRight,
      //       tileMode: TileMode.mirror,
      //     ).createShader(bounds);
      //   },
      //   child: 
        new Icon(
          IconData(0xe900, fontFamily: "fetch"),
          size: 50.0,
          color: Colors.black,
          // color: Theme.of(context).primaryColor,
        ),
      // ),
    ),
    );
  }

  Widget _buildLoginButtons(BoxConstraints constraints) {
    return new Container(
      height: constraints.maxHeight / 3.5,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 122, 255, 1.0),
            Color.fromRGBO(0, 175, 230, 1.0),
            Color.fromRGBO(0, 255, 230, 1.0),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: new Offset(0.0, -3.0),
            blurRadius: 5.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: new SafeArea(
        bottom: true,
        top: false,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              IconData(0xe900, fontFamily: "fetch"),
              color: Colors.white,
              size: 35.0,
            ),
            new Divider(
              color: Colors.transparent,
              height: 15.0,
            ),
            new LoginButton(
              text: "LOGIN",
              textColor: Theme.of(context).primaryColor,
              colors: [
                Colors.white,
                Colors.white,
              ],
              onPressed: 
              () {
                Navigator.of(context).push(
                  SlideUpRoute(
                    page: LoginEmailPage(),
                  ),
                );
              },
            ),
            new Divider(
              height: 15.0,
            ),
            new LoginButton(
              text: "SIGN UP",
              textColor: Theme.of(context).primaryColor,
              colors: [
                Colors.white,
                Colors.white,
              ],
              onPressed: () {
                Navigator.of(context).push(
                  SlideUpRoute(
                    page: OwnerAccountPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return new Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Expanded(
                  child: new Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      _buildBackImage(),
                      _buildFrontImage(),
                    ],
                  ),
                ),
                new Container(
                  height: (constraints.maxHeight / 3.5) - 25.0,
                )
              ],
            ),
            new Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: _buildLoginButtons(constraints),
            ),
            // new Positioned(
            //   top: 0.0,
            //   left: 0.0,
            //   right: 0.0,
            //   child: _buildFetchLogo()
            // ),
            
            // _buildFetchLogo(),
          ],
        );
      }),
    );
  }
}
