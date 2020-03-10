class HistoryState {
  List<Map<String, Map<dynamic, dynamic>>> sessions;

  HistoryState({
    this.sessions
  });

  factory HistoryState.initial() {
    return  HistoryState(
      sessions: []
    );
  }

  HistoryState copyWith({
    sessions
  }){
    return  HistoryState(
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is HistoryState &&
        runtimeType == other.runtimeType &&
        sessions == other.sessions;

  @override
  int get hashCode =>
    sessions.hashCode;
}
