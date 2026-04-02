enum MatchStatus { live, upcoming, finished }

class MatchModel {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeGoals;
  final int awayGoals;
  final MatchStatus status;
  final int homeVotes;
  final int awayVotes;
  final String? arena;
  final String? time;
  final String? date;

  MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeGoals,
    required this.awayGoals,
    required this.status,
    required this.homeVotes,
    required this.awayVotes,
    this.arena,
    this.time,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeGoals': homeGoals,
      'awayGoals': awayGoals,
      'status': status.name,
      'homeVotes': homeVotes,
      'awayVotes': awayVotes,
      'arena': arena,
      'time': time,
      'date': date,
    };
  }

  factory MatchModel.fromMap(String id, Map<String, dynamic> map) {
    return MatchModel(
      id: id,
      homeTeam: map['homeTeam'] ?? '',
      awayTeam: map['awayTeam'] ?? '',
      homeGoals: (map['homeGoals'] ?? 0).toInt(),
      awayGoals: (map['awayGoals'] ?? 0).toInt(),
      status: MatchStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => MatchStatus.upcoming,
      ),
      homeVotes: (map['homeVotes'] ?? 0).toInt(),
      awayVotes: (map['awayVotes'] ?? 0).toInt(),
      arena: map['arena'],
      time: map['time'],
      date: map['date'],
    );
  }

  MatchModel copyWith({
    String? id,
    String? homeTeam,
    String? awayTeam,
    int? homeGoals,
    int? awayGoals,
    MatchStatus? status,
    int? homeVotes,
    int? awayVotes,
    String? arena,
    String? time,
    String? date,
  }) {
    return MatchModel(
      id: id ?? this.id,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeGoals: homeGoals ?? this.homeGoals,
      awayGoals: awayGoals ?? this.awayGoals,
      status: status ?? this.status,
      homeVotes: homeVotes ?? this.homeVotes,
      awayVotes: awayVotes ?? this.awayVotes,
      arena: arena ?? this.arena,
      time: time ?? this.time,
      date: date ?? this.date,
    );
  }
}
