import 'package:wikiapp/modules/notebook/models/NotebookState.dart';
import 'package:redux/redux.dart';

import 'action.dart';

final Reducer <NotebookState> notebookReducer = combineReducers ([
   TypedReducer<NotebookState, LoadNoteBookState>(loadNotebookData),
   TypedReducer<NotebookState, SaveNotebook>(saveNotebookReducer),
   TypedReducer<NotebookState, UpdateNotebook>(updateNotebookReducer),
   TypedReducer<NotebookState, DeleteNotebook>(deleteNotebookReducer),
   TypedReducer<NotebookState, ReOrderNotebook>(reorderNotebookReducer),
]);

NotebookState loadNotebookData(NotebookState state, action) {
  state = state.copyWith(
    notes: action.notebookState.notes
  );
  return state;
}

NotebookState saveNotebookReducer(NotebookState state, action) {
  List<Note> notes = []..addAll(state.notes)..add(Note(note: action.note, url: action.url));

  state = state.copyWith(
    notes: notes
  );

  return state;
}

NotebookState updateNotebookReducer(NotebookState state, action) {
  Note newNote = Note(note: action.Note, url: state.notes[action.index].url);
  List<Note> notes = []..addAll(state.notes)..replaceRange(action.index, action.index + 1, [newNote]);
  state = state.copyWith(
    notes: notes
  );

  return state;
}

NotebookState deleteNotebookReducer(NotebookState state, action) {
  List<Note> notes = []..addAll(state.notes)..remove(state.notes[action.index]);
  state = state.copyWith(
    notes: notes
  );

  return state;
}

NotebookState reorderNotebookReducer(NotebookState state, action) {
  final oldIndex = action.oldIndex;
  final newIndex = action.newndex;
  final notes = state.notes;
  List<Note> newNotes = []..addAll(notes)
    ..replaceRange(action.oldIndex,oldIndex + 1,[notes[newIndex]])
    ..replaceRange(action.Index,newIndex + 1,[notes[oldIndex]]);
  state = state.copyWith(
    notes: newNotes
  );

  return state;
}
