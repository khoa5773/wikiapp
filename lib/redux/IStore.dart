
import 'package:wikiapp/modules/notebook/models/NotebookState.dart';
import 'package:wikiapp/modules/read/models/ReadState.dart';

class AppState {
  final ReadState readState;
  final NotebookState notebookState;

  AppState({this.readState, this.notebookState});

  factory AppState.initial() {
    return AppState(
      readState: ReadState.initial(), 
      notebookState: NotebookState.initial(),
    );
  }

  AppState copyWith() {
    return  AppState(
      readState: readState ?? this.readState,
      notebookState: notebookState ?? this.notebookState,
    );
  }

  static AppState fromJson(dynamic json) {
    List<ReadSession> sessions = [];
    for (var session in json['readState']) {
      sessions.add(ReadSession(
          readSessions: session['readSessions'],
          urls: session['urls'],
          endAt:  DateTime.fromMillisecondsSinceEpoch(session['endAt'])));
    }
    List<Note> notes = [];
    for (var note in json['notebookState']) {
      notes.add(Note(url: note['url'], note: note['note']));
    }
    return AppState(
        readState: ReadState(sessions: sessions),
        notebookState: NotebookState(notes: notes));
  }

  dynamic toJson() {
    var res = {
      'readState': readState.toJson(),
      'notebookState': notebookState.toJson(),
    };
    return res;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          readState == other.readState &&
          notebookState == other.notebookState;

  @override
  int get hashCode => readState.hashCode ^ notebookState.hashCode;
}
