import 'package:flutter/material.dart';
import 'package:fetch/models/profile.dart';

class MatchEngine extends ChangeNotifier {
  final List<DogMatch> _matches;
  int _previousMatchIndex;
  int _currentMatchIndex;
  int _nextMatchIndex;

  MatchEngine({
    List<DogMatch> matches,
  }) : _matches = matches {
    _previousMatchIndex = 0;
    _currentMatchIndex = 1;
    _nextMatchIndex = 2;
  }

  DogMatch get previousMatch =>
      _previousMatchIndex != null ? _matches[_previousMatchIndex] : null;

  DogMatch get currentMatch => _matches[_currentMatchIndex];

  DogMatch get nextMatch => _matches[_nextMatchIndex];

  void cycleMatch() {
    if (currentMatch.decision != Decision.undecided &&
        currentMatch.decision != Decision.rewind) {
      currentMatch.reset();
      print(_previousMatchIndex);
      print(_currentMatchIndex);
      print(_nextMatchIndex);

      _previousMatchIndex = _currentMatchIndex;
      _currentMatchIndex = _nextMatchIndex;
      _nextMatchIndex =
          _nextMatchIndex < _matches.length - 1 ? _nextMatchIndex + 1 : 0;

      notifyListeners();
    } else {
      currentMatch.reset();

      _nextMatchIndex = _currentMatchIndex;
      _currentMatchIndex = _previousMatchIndex;
      _previousMatchIndex = null;

      notifyListeners();
    }
  }
}

class DogMatch extends ChangeNotifier {
  final Profile profile;
  Decision decision = Decision.undecided;

  DogMatch({
    this.profile,
  });

  void like() {
    if (decision == Decision.undecided) {
      decision = Decision.like;
      notifyListeners();
    }
  }

  void dislike() {
    if (decision == Decision.undecided) {
      decision = Decision.dislike;
      notifyListeners();
    }
  }

  void superLike() {
    if (decision == Decision.undecided) {
      decision = Decision.superLike;
      notifyListeners();
    }
  }

  void rewind() {
    if (decision == Decision.undecided) {
      decision = Decision.rewind;
      notifyListeners();
    }
  }

  void reset() {
    if (decision != Decision.undecided) {
      decision = Decision.undecided;
      notifyListeners();
    }
  }
}

enum Decision { like, dislike, superLike, undecided, rewind }
