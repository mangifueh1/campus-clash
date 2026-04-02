import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_clash/core/models/match_model.dart';
import 'package:flutter/material.dart';

class MatchesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MatchModel> _matches = [];

  MatchesProvider() {
    _initMatchesListener();
  }

  void _initMatchesListener() {
    _firestore.collection('matches').snapshots().listen((snapshot) {
      _matches = snapshot.docs
          .map((docSnapshot) =>
              MatchModel.fromMap(docSnapshot.id, docSnapshot.data()))
          .toList();
      notifyListeners();
    });
  }

  List<MatchModel> get matches => _matches;

  List<MatchModel> get liveMatches =>
      _matches.where((m) => m.status == MatchStatus.live).toList();
  List<MatchModel> get upcomingMatches =>
      _matches.where((m) => m.status == MatchStatus.upcoming).toList();
  List<MatchModel> get finishedMatches =>
      _matches.where((m) => m.status == MatchStatus.finished).toList();

  Future<void> addMatch(MatchModel match) async {
    try {
      await _firestore.collection('matches').doc(match.id).set(match.toMap());
    } catch (e) {
      debugPrint('Error adding match: $e');
    }
  }

  Future<void> updateScore(String id, int home, int away) async {
    try {
      await _firestore.collection('matches').doc(id).update({
        'homeGoals': home,
        'awayGoals': away,
      });
    } catch (e) {
      debugPrint('Error updating score: $e');
    }
  }

  Future<void> startMatch(String id) async {
    try {
      await _firestore.collection('matches').doc(id).update({
        'status': MatchStatus.live.name,
      });
    } catch (e) {
      debugPrint('Error starting match: $e');
    }
  }

  Future<void> endMatch(String id) async {
    try {
      await _firestore.collection('matches').doc(id).update({
        'status': MatchStatus.finished.name,
      });
    } catch (e) {
      debugPrint('Error ending match: $e');
    }
  }

  Future<void> voteForTeam(String id, bool isHome) async {
    try {
      await _firestore.collection('matches').doc(id).update({
        isHome ? 'homeVotes' : 'awayVotes': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('Error voting: $e');
    }
  }
}
