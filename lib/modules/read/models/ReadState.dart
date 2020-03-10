class ReadSession {
  final Map readSessions;
  final List urls;
  final DateTime endAt;

  ReadSession({
    this.readSessions,
    this.urls,
    this.endAt
  });
}

class ReadState {
  List<ReadSession> sessions;

  ReadState({
    this.sessions
  });

  factory ReadState.initial() {
    return  ReadState(
      sessions: []
    );
  }

  ReadState copyWith({
    List<ReadSession> sessions
  }){
    return  ReadState(
      sessions: sessions ?? this.sessions,
    );
  }

  static ReadState fromJson(dynamic json) =>
      ReadState(
        sessions: json,
      );

  dynamic toJson() {
    var res = [];
    for (var session in sessions) {
      res.add({
        'readSessions': session.readSessions,
        'urls': session.urls,
        'endAt': session.endAt.millisecondsSinceEpoch
      });
    }
    return res;
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is ReadState &&
        runtimeType == other.runtimeType &&
        sessions == other.sessions;

  @override
  int get hashCode =>
    sessions.hashCode;
}