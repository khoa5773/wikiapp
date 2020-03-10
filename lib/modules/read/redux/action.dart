class LoadReadState {
  final readState;
  LoadReadState(this.readState);
}

class SaveReadSession {
  final readSessions;
  final isSession;
  final urls;
  SaveReadSession({this.readSessions, this.isSession, this.urls});
}
