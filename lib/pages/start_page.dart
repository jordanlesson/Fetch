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
    return new FractionallySizedBox(
      heightFactor: 1 / 3,
      alignment: Alignment.topCenter,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [
              Color.fromRGBO(0, 122, 255, 1.0),
              Color.fromRGBO(0, 255, 230, 1.0),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.mirror,
          ).createShader(bounds);
        },
        child: new Icon(
          IconData(0xe900, fontFamily: "fetch"),
          size: 150.0,
          color: Colors.white,
          // color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildLoginButtons() {
    return new FractionallySizedBox(
      alignment: Alignment.bottomCenter,
      heightFactor: 1 / 3,
      child: new Container(
        color: Colors.transparent,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new LoginButton(
              text: "LOGIN",
              onPressed: () {
                Navigator.of(context).push(
                  SlideUpRoute(
                    page: LoginEmailPage(),
                  ),
                );
              },
            ),
            new Divider(
              height: 10.0,
            ),
            new LoginButton(
              text: "SIGN UP",
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
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildBackImage(),
          _buildFrontImage(),
          _buildLoginButtons(),
          // _buildFetchLogo(),
        ],
      ),
    );
  }
}
