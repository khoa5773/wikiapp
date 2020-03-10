import 'package:wikiapp/modules/read/models/ReadState.dart';
import 'package:redux/redux.dart';

import 'action.dart';

final Reducer <ReadState> readReducer = combineReducers ([
   TypedReducer<ReadState, LoadReadState>(loadReadData),
   TypedReducer<ReadState, SaveReadSession>(saveReadSession),
]);

ReadState loadReadData(ReadState state, action) {
  state = state.copyWith(
    sessions: action.readState.sessions
  );
  return state;
}

ReadState saveReadSession(ReadState state, action) {
  List<ReadSession> sessions;
  if (action.isSession){
    sessions = []..addAll(state.sessions)..add(ReadSession(endAt: DateTime.now(), readSessions: action.readSessions, urls: action.urls));
  }

  if (!action.isSession) {
    ReadSession lastSession = state.sessions.last;
    Map lastArticleSessions = lastSession.readSessions;
    action.readSessions.forEach((key, value) => {
      if (lastArticleSessions.containsKey(key)) {
        lastArticleSessions[key] += value
      } else {
        lastArticleSessions[key] = value
      }
    });
    List lastUrlsRelation = lastSession.urls..addAll(action.urls);
    sessions = []..addAll(state.sessions)..removeLast()..add(ReadSession(endAt: DateTime.now(), readSessions: lastArticleSessions, urls: lastUrlsRelation));
  }

  state = state.copyWith(
    sessions: sessions
  );

  return state;
}
