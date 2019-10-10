import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fetch/pages/profile_details_page.dart';
import 'package:fetch/matches.dart';
import 'package:fetch/transitions.dart';
import 'photos.dart';
import 'package:fetch/models/profile.dart';
import 'dart:math';
import 'dart:async';
import 'package:fetch/resources/dog_repository.dart';

class CardStack extends StatefulWidget {
  final List<Profile> profiles;
  final List<Profile> swipedDogs;
  final String currentUser;
  final Profile currentDog;
  final DogRepository _dogRepository;
  final void Function(SlideDirection) onSlideOutComplete;
  final void Function(List<Profile>, List<Profile>) onRewindComplete;

  CardStack(
      {Key key,
      this.currentDog,
      this.profiles,
      this.swipedDogs,
      this.currentUser,
      @required DogRepository dogRepository,
      this.onRewindComplete,
      this.onSlideOutComplete})
      : assert(dogRepository != null),
        _dogRepository = dogRepository,
        super(key: key);

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> with TickerProviderStateMixin {
  DogMatch _currentMatch;
  double _nextCardScale = 0.9;
  double _cardDecisionOpacity = 0.0;
  Offset _cardOffset = new Offset(0.0, 0.0);
  Key _frontCard;
  bool rewinded;
  int _cardIndex;
  Tween<Offset> slideInTween;
  AnimationController rewindAnimation;
  Offset _rewindStart;
  Offset _rewindCardOffset;

  DogRepository get _dogRepository => widget._dogRepository;

  void initState() {
    super.initState();

    _cardIndex = 0;

    rewindAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          _rewindCardOffset = slideInTween.evaluate(rewindAnimation);
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            widget.onRewindComplete(widget.profiles, widget.swipedDogs);
            slideInTween = null;
            _rewindCardOffset = null;
          });
        }
      });

    _frontCard = new Key(widget.profiles[0].id);

  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    if (oldWidget.profiles != widget.profiles) {
      _cardOffset = const Offset(0.0, 0.0);
      _cardDecisionOpacity = 0.0;
      _rewindCardOffset = null;
      _frontCard = new Key(widget.profiles[0].id);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    
  }


  Widget _buildBackCard() {

    return widget.profiles.length >= _cardIndex + 2
        ? new Transform(
            transform: Matrix4.identity()
              ..scale(_nextCardScale, _nextCardScale),
            alignment: Alignment.center,
            child: new ProfileCard(
                profile: widget.profiles[_cardIndex + 1],
                currentUser: widget.currentUser,
                currentDog: widget.currentDog,
                ),
          )
        : new Container();
  }

  Widget _buildDecisionIcon(BoxConstraints constraints) {
    final isInRightRegion = (_cardOffset.dx / constraints.maxWidth) > 0.1;
    final isInLeftRegion = (_cardOffset.dx / constraints.maxWidth) < -0.1;
    final isInTopRegion = (_cardOffset.dy / constraints.maxHeight) < -0.1;

    if (isInTopRegion) {
      return new Align(
        alignment: Alignment.bottomCenter,
        child: new Opacity(
          opacity: _cardDecisionOpacity,
          child: new Container(
            padding: EdgeInsets.all(constraints.maxWidth / 16),
            child: new Icon(
              IconData(0xe900, fontFamily: "treat"),
              color: Theme.of(context).primaryColor,
              size: constraints.maxWidth / 2,
            ),
          ),
        ),
      );
    } else if (isInRightRegion) {
      return new Align(
        alignment: Alignment.topLeft,
        child: new Opacity(
          opacity: _cardDecisionOpacity,
          child: new Container(
            padding: EdgeInsets.all(constraints.maxWidth / 16),
            child: new Icon(
              Icons.thumb_up,
              color: Colors.green,
              size: constraints.maxWidth / 2,
            ),
          ),
        ),
      );
    } else if (isInLeftRegion) {
      return new Align(
        alignment: Alignment.topRight,
        child: new Opacity(
          opacity: _cardDecisionOpacity,
          child: new Container(
            padding: EdgeInsets.all(constraints.maxWidth / 16),
            child: new Icon(
              Icons.thumb_down,
              color: Colors.red,
              size: constraints.maxWidth / 2,
            ),
          ),
        ),
      );
    } else {
      return new Container();
    }
  }

  Widget _buildFrontCard() {
    return widget.profiles.length > 0
        ? new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return new Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  new ProfileCard(
                    profile: widget.profiles[_cardIndex],
                    currentDog: widget.currentDog,
                    currentUser: widget.currentUser,
                    isDecidable: false,
                    key: _frontCard,
                  ),
                  _buildDecisionIcon(constraints)
                ],
              );
            },
          )
        : new Container();
  }

  Widget _buildRewindCard(BoxConstraints constraints) {
    _rewindStart = new Offset(-constraints.maxWidth, 0.0);

    return widget.profiles.length > 0 && widget.swipedDogs.isNotEmpty
        ? new Opacity(
          opacity: rewindAnimation.isAnimating ? rewindAnimation.value : 0.0,
          child: new ProfileCard(
            profile: widget.swipedDogs.last,
            currentDog: widget.currentDog,
            currentUser: widget.currentUser,
            isDecidable: false,
          ),
          )
        : new Container();
  }

  Widget _buildRewindButton() {
    return widget.swipedDogs.isNotEmpty
        ? Positioned(
            top: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: new GestureDetector(
              child: new Container(
                height: 50.0,
                width: 50.0,
                margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(230, 92, 100, 1.0),
                      Color.fromRGBO(249, 212, 35, 1.0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 3.0),
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: new Icon(
                  Icons.undo,
                  color: Colors.white,
                ),
              ),
              onTap: _onRewindPressed,
            ),
          )
        : new Container();
  }

  // Widget _buildPreviousCard() {
  //   print(previousCardHidden);
  //   return widget.matchEngine.previousMatch != null
  //       ? new Offstage(
  //           offstage: previousCardHidden,
  //           child: ProfileCard(
  //             profile: widget.matchEngine.currentMatch.profile,
  //           ),
  //         )
  //       : new Container();
  // }

  SlideDirection _desiredSlideOutDirection() {
    // print(widget.matchEngine.currentMatch.decision);
    // switch (widget.matchEngine.currentMatch.decision) {
    //   case Decision.dislike:
    //     return SlideDirection.left;
    //   case Decision.like:
    //     return SlideDirection.right;
    //   case Decision.superLike:
    //     return SlideDirection.up;
    //   case Decision.rewind:
    //     return SlideDirection.back;
    //   default:
    //     return null;
    // }
  }

  void _onSlideUpdate(Offset cardOffset) {
    setState(() {
      _cardOffset = cardOffset;

      _nextCardScale =
          0.9 + (0.1 * (cardOffset.distance / 100.0)).clamp(0.0, 0.1);

      _cardDecisionOpacity =
          (cardOffset.distance / (MediaQuery.of(context).size.width / 2))
              .clamp(0.0, 1.0);
    });
  }

  //   if (direction == SlideDirection.back) {
  //     setState(() {
  //       rewinded = true;
  //     });
  //   }

  //   widget.matchEngine.cycleMatch();
  // }

  void _onRewindPressed() {
    slideInTween = Tween(begin: _rewindStart, end: const Offset(0.0, 0.0));
    rewindAnimation.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // print(_desiredSlideOutDirection());
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return new Stack(
          children: <Widget>[
            new DraggableCard(
              card: _buildBackCard(),
              isDraggable: false,
            ),
            new DraggableCard(
              card: _buildFrontCard(),
              slideTo: _desiredSlideOutDirection(),
              onSlideUpdate: _onSlideUpdate,
              onSlideOutComplete: widget.onSlideOutComplete,
            ),
            new Transform.translate(
              offset: _rewindCardOffset != null
                  ? _rewindCardOffset
                  : new Offset(-(constraints.maxWidth), 0.0),
              child: new DraggableCard(
                isDraggable: false,
                card: _buildRewindCard(constraints),
              ),
            ),
            _buildRewindButton(),
            // new DraggableCard,
            //   card: _buildPreviousCard(),
            //   isDraggable: false,
            // )
          ],
        );
      },
    );
  }
}

enum SlideDirection {
  left,
  right,
  up,
}

class DraggableCard extends StatefulWidget {
  final Widget card;
  final bool isDraggable;
  final SlideDirection slideTo;
  final Function(Offset cardOffset) onSlideUpdate;
  final Function(SlideDirection direction) onSlideOutComplete;
  final Function() onRewindComplete;

  DraggableCard({
    this.card,
    this.isDraggable = true,
    this.slideTo,
    this.onSlideUpdate,
    this.onSlideOutComplete,
    this.onRewindComplete,
  });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Decision decision;
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  Offset slideBackStart;
  SlideDirection slideOutDirection;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;
  AnimationController rewindAnimation;
  GlobalKey profileCardKey = new GlobalKey(debugLabel: "profile_card_key");
  GlobalKey _cardBackgroundKey = new GlobalKey();
  Rect _cardBackgroundRect;
  Rect _cardRect;

  void initState() {
    super.initState();

    slideBackAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(
              slideBackStart,
              const Offset(0.0, 0.0),
              Curves.elasticOut.transform(slideBackAnimation.value),
            );

            if (widget.onSlideUpdate != null) {
              widget.onSlideUpdate(cardOffset);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          cardOffset = slideOutTween.evaluate(slideOutAnimation);

          if (widget.onSlideUpdate != null) {
            widget.onSlideUpdate(cardOffset);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;
            cardOffset = const Offset(0.0, 0.0);
            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete(slideOutDirection);
            }
          });
        }
      });

    rewindAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          cardOffset = slideOutTween.evaluate(rewindAnimation);

          if (widget.onSlideUpdate != null) {
            widget.onSlideUpdate(cardOffset);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;
            if (widget.onSlideOutComplete != null) {
              widget.onRewindComplete();
            }
          });
        }
      });
    WidgetsBinding.instance.addPostFrameCallback((_) => _getCardInfo(context));
  }

  void _getCardInfo(BuildContext context) {
    final RenderBox backgroundRenderBox =
        _cardBackgroundKey.currentContext.findRenderObject();
    final cardBackgroundSize = backgroundRenderBox.size;

    final backgroundTopLeft = cardBackgroundSize
        .topLeft(backgroundRenderBox.localToGlobal(const Offset(0.0, 0.0)));
    final backgroundBottomRight = backgroundRenderBox.size
        .bottomRight(backgroundRenderBox.localToGlobal(const Offset(0.0, 0.0)));
    _cardBackgroundRect = Rect.fromLTRB(
      backgroundTopLeft.dx,
      backgroundTopLeft.dy,
      backgroundBottomRight.dx,
      backgroundBottomRight.dy,
    );
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.key != oldWidget.card.key) {
      cardOffset = const Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    //slideOutAnimation.dispose();
    slideBackAnimation.dispose();
    //rewindAnimation.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.isDraggable) {
      dragStart = details.globalPosition;

      if (slideBackAnimation.isAnimating) {
        slideBackAnimation.stop(
          canceled: true,
        );
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.isDraggable) {
      setState(() {
        dragPosition = details.globalPosition;
        cardOffset = dragPosition - dragStart;

        if (widget.onSlideUpdate != null) {
          widget.onSlideUpdate(cardOffset);
        }
      });
    }
  }

  // Offset _chooseRandomDragStart() {
  //   final cardTopLeft = _cardRect.topLeft;
  //   final dragStartY = _cardRect.size.height *
  //           (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
  //       cardTopLeft.dy;
  //   return new Offset(_cardRect.size.width / 2 + cardTopLeft.dx, dragStartY);
  // }

  void _slideRight() async {
    final screenWidth = _cardBackgroundRect.size.width;
    dragStart = const Offset(0.0, 0.0);
    slideOutTween = Tween(
        begin: const Offset(0.0, 0.0), end: new Offset(2 * screenWidth, 0.0));
    slideOutAnimation.forward(from: 0.0);
  }

  void _slideLeft() async {
    final screenWidth = _cardBackgroundRect.size.width;
    dragStart = const Offset(0.0, 0.0);
    slideOutTween = Tween(
        begin: const Offset(0.0, 0.0), end: new Offset(-2 * screenWidth, 0.0));
    slideOutAnimation.forward(from: 0.0);
  }

  void _slideUp() async {
    final screenHeight = _cardBackgroundRect.size.height;
    dragStart = const Offset(0.0, 0.0);
    slideOutTween = Tween(
        begin: const Offset(0.0, 0.0),
        end: new Offset(0.0, -1.5 * screenHeight));
    slideOutAnimation.forward(from: 0.0);
  }

  // void _slideBack() async {
  //   final screenHeight = _cardBackgroundRect.size.height;
  //   dragStart = const Offset(0.0, 0.0);
  //   slideOutTween = Tween(
  //     begin: new Offset(0.0, 1.5 * screenHeight),
  //     end: const Offset(0.0, 0.0),
  //   );
  //   widget.onSlideOutComplete(SlideDirection.back);
  //   rewindAnimation.forward(from: 0.0);
  // }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInRightRegion = (cardOffset.dx / context.size.width) > 0.45;
    final isInLeftRegion = (cardOffset.dx / context.size.width) < -0.45;
    final isInTopRegion = (cardOffset.dy / context.size.height) < -0.40;

    setState(() {
      if (isInRightRegion || isInLeftRegion) {
        slideOutTween = new Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));
        slideOutAnimation.forward(from: 0.0);
        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else if (isInTopRegion) {
        slideOutTween = new Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.height));
        slideOutAnimation.forward(from: 0.0);
        slideOutDirection = SlideDirection.up;
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return const Offset(0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return new Center(
          child: new Transform(
            transform:
                Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(_cardBackgroundRect)),
            origin: _rotationOrigin(_cardBackgroundRect),
            child: new Container(
              key: _cardBackgroundKey,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              padding: EdgeInsets.all(16.0),
              child: new GestureDetector(
                key: profileCardKey,
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: widget.card,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileCard extends StatefulWidget {
  final Profile profile;
  final String currentUser;
  final Profile currentDog;
  final bool isDecidable;

  ProfileCard({
    Key key,
    this.profile,
    this.currentDog,
    this.currentUser,
    this.isDecidable = true,
  }) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int visiblePhotoIndex;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = 0;
  }

  @override
  void didUpdateWidget(ProfileCard oldWidget) {
    if (oldWidget != widget) {
      Future.delayed(Duration(milliseconds: 500), () {
        visiblePhotoIndex = 0;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _previousImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex > 0 ? visiblePhotoIndex - 1 : 0;
    });
  }

  void _nextImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex < widget.profile.photos.length - 1
          ? visiblePhotoIndex + 1
          : visiblePhotoIndex;
    });
  }

  Widget _buildBackground() {
    return new PhotoBrowser(
      photos: widget.profile.photos,
      visiblePhotoIndex: visiblePhotoIndex,
      nextImage: _nextImage,
      previousImage: _previousImage,
    );
  }

  Widget _buildProfileInfo() {
    return new Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: new Container(
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new RichText(
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        new TextSpan(
                          text: widget.profile.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35.0,
                              fontFamily: "Proxima Nova",
                              fontWeight: FontWeight.w700),
                        ),
                        new TextSpan(
                          text: " ",
                          style: TextStyle(
                            fontSize: 35.0,
                            fontFamily: "Proxima Nova",
                          ),
                        ),
                        new TextSpan(
                          text:
                              Profile().convertDate(widget.profile.dateOfBirth),
                              
                              
                          style: TextStyle(
                            
                            color: Colors.white,
                            fontSize: 30.0,
                            fontFamily: "Proxima Nova",
                            //fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Text(
                    widget.profile.breed,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: "Proxima Nova"),
                  )
                ],
              ),
            ),
            new GestureDetector(
              child: new Icon(
                Icons.info,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(
                  SlideUpRoute(
                    page: new WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: new ProfileDetailsPage(
                        profile: widget.profile,
                        currentDog: widget.currentDog,
                        currentUser: widget.currentUser,
                        visiblePhotoIndex: visiblePhotoIndex,
                        isDecidable: widget.isDecidable,
                      ),
                    ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          new BoxShadow(
            color: Color(0x11000000),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: new Material(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildBackground(),
              _buildProfileInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

