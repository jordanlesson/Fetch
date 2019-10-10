import 'package:admob_flutter/admob_flutter.dart';
import 'package:fetch/blocs/leaderboard_bloc/bloc.dart';
import 'package:fetch/blocs/leaderboard_bloc/leaderboard_bloc.dart';
import 'package:fetch/pages/dog_breed_page.dart';
import 'package:fetch/pages/profile_details_page.dart';
import 'package:fetch/models/profile.dart';
import 'package:fetch/resources/dog_repository.dart';
import 'package:fetch/transitions.dart';
import 'package:fetch/ui/input_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LeaderboardPage extends StatefulWidget {
  final FirebaseUser user;

  LeaderboardPage({@required this.user});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with AutomaticKeepAliveClientMixin<LeaderboardPage> {
  final DogRepository _dogRepository = DogRepository();
  LeaderboardBloc _leaderboardBloc;

  @override
  void initState() {
    super.initState();

    _leaderboardBloc = LeaderboardBloc(
      dogRepository: _dogRepository,
    );

    _leaderboardBloc.dispatch(
      LeaderboardStarted(),
    );
  }

  @override
  void dispose() { 
    _leaderboardBloc.dispose();
    super.dispose();
  }

  String _breed;

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Icon(
        Icons.poll,
        color: Colors.black,
      ),
      centerTitle: true,
      leading: new BackButton(
        color: Colors.black,
      ),
      elevation: 0.0,
    );
  }

  Widget _buildGridView(List<Profile> dogs) {
    
    return new Expanded(
      child: new StaggeredGridView.count(
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.only(bottom: 16.0),
        crossAxisCount: 3,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        staggeredTiles: List.generate(
          dogs.length >= 18 ? dogs.length + 1 : dogs.length,
          (index) {
            if (index == 0) {
              return StaggeredTile.count(3, 2);
            } else if (index == 1) {
              return StaggeredTile.count(2, 2);
            } else if (index == 2) {
              return StaggeredTile.count(1, 2);
            } else if (index == 12 && dogs.length >= 18) {
              return StaggeredTile.count(3, 1); // AD PLACEMENT
            } else {
              return StaggeredTile.count(1, 1);
            }
          },
        ),
        children: List<Widget>.generate(
          dogs.length >= 18 ? dogs.length + 1 : dogs.length,
          (int index) {
            return dogs.length >= 18 && index == 12 ? new AdmobBanner(
              adSize: AdmobBannerSize.BANNER,
              adUnitId: "ca-app-pub-7132470146221772/1339722046",
              listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                switch (event) {
                  case AdmobAdEvent.loaded:
                    print('Admob banner loaded!');
                    break;

                  case AdmobAdEvent.opened:
                    print('Admob banner opened!');
                    break;

                  case AdmobAdEvent.closed:
                    print('Admob banner closed!');
                    break;

                  case AdmobAdEvent.failedToLoad:
                    print(
                        'Admob banner failed to load. Error code: ${args['errorCode']}');
                    break;
                  case AdmobAdEvent.clicked:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.impression:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.leftApplication:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.completed:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.rewarded:
                    // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.started:
                    // TODO: Handle this case.
                    break;
                }
              },
            ) : new GestureDetector(
              child: new LeaderboardCell(
                dog: dogs.length >= 18 && index > 12 ? dogs[index - 1] : dogs[index],
              ),
              onTap: () {
                Navigator.of(context).push(
                  SlideUpRoute(
                    page: ProfileDetailsPage(
                      currentUser: widget.user.uid,
                      currentDog: null,
                      profile: dogs.length >= 18 && index > 12 ? dogs[index - 1] : dogs[index],
                      isDecidable: false,
                      visiblePhotoIndex: 0,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showFilterOptions() {
    Navigator.of(context)
        .push(
      SlideUpRoute(
        page: new DogBreedPage(),
      ),
    )
        .then((breed) {
      if (breed != null) {
        setState(() {
          _breed = breed;
          _leaderboardBloc.dispatch(
            OnBreedFilterChanged(
              breed: _breed,
            ),
          );
        });
      }
    });
  }

  Widget _buildLoading() {
    return new Expanded(
      child: new Center(
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
              "Fetching Leaderboard",
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
      ),
    );
  }

  Widget _buildFailure() {
    return new Expanded(
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Container(
            //   margin: EdgeInsets.only(bottom: 5.0),
            //   child: new Icon(
            //     Icons.,
            //     color: Colors.black,
            //     size: 35.0,
            //   ),
            // ),
            new Text(
              "Unable To Find Any Dogs",
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
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(16.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Text(
                    "TOP DOGS",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: "Proxima Nova",
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                new GestureDetector(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(right: 5.0),
                        child: new Icon(
                          Icons.pets,
                          color: Theme.of(context).primaryColor,
                          size: 18.0,
                        ),
                      ),
                      new Text(
                        _breed != null ? _breed : "ALL",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14.0,
                          fontFamily: "Proxima Nova",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      new Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).primaryColor,
                        size: 18.0,
                      ),
                      _breed != null
                          ? new GestureDetector(
                              child: new Icon(
                                Icons.clear,
                                color: Colors.black,
                                size: 20.0,
                              ),
                              onTap: () {
                                setState(() {
                                  _breed = null;
                                  _leaderboardBloc.dispatch(
                                    OnBreedFilterChanged(
                                      breed: _breed,
                                    ),
                                  );
                                });
                              })
                          : new Container(),
                    ],
                  ),
                  onTap: _showFilterOptions,
                ),
              ],
            ),
          ),
          new BlocProvider(
            bloc: _leaderboardBloc,
            child: new BlocBuilder(
                bloc: _leaderboardBloc,
                builder: (BuildContext context, LeaderboardState state) {
                  if (state.isLoading) {
                    return _buildLoading();
                  }
                  if (state.isFailure) {
                    return _buildFailure();
                  }
                  if (state.isSuccess) {
                    return _buildGridView(state.dogs);
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class LeaderboardCell extends StatelessWidget {
  final Profile dog;

  LeaderboardCell({@required this.dog});

  String textFormatter(int statistic) {
    if (statistic >= 1000000000) {
      return "${statistic.toString()[0]}B";
    } else if (statistic >= 100000000) {
      return "${statistic.toString()[0]}${statistic.toString()[1]}${statistic.toString()[2]}M";
    } else if (statistic >= 10000000) {
      return "${statistic.toString()[0]}${statistic.toString()[1]}M";
    } else if (statistic >= 1000000) {
      return "${statistic.toString()[0]}.${statistic.toString()[1]}M";
    } else if (statistic >= 100000) {
      return "${statistic.toString()[0]}${statistic.toString()[1]}.${statistic.toString()[2]}K";
    } else if (statistic >= 10000) {
      return "${statistic.toString()[0]}.${statistic.toString()[1]}K";
    } else if (statistic >= 5000) {
      return "${statistic.toString()[0]}K";
    }
    return statistic.toString();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        image: DecorationImage(
          image: NetworkImage(
            dog.photos[0],
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: new Column(
        children: <Widget>[
          new Expanded(
            child: new Align(
              alignment: Alignment.topLeft,
            ),
          ),
          new Align(
            alignment: Alignment.bottomRight,
            child: new Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.75),
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: new Text(
                "${textFormatter(dog.treats.length)} Treats",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
