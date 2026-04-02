import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VotingProvider extends ChangeNotifier {
  SharedPreferences? _prefs;
  
  VotingProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  bool hasVoted(String matchId) {
    if (_prefs == null) return false;
    return _prefs!.containsKey('vote_$matchId');
  }

  bool? votedForHome(String matchId) {
    if (_prefs == null) return null;
    return _prefs!.getBool('vote_$matchId');
  }

  Future<void> registerVoteLocally(String matchId, bool isHome) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    await _prefs!.setBool('vote_$matchId', isHome);
    notifyListeners();
  }
}
