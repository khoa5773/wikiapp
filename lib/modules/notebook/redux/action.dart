class LoadNoteBookState {
  final notebookState;
  LoadNoteBookState(this.notebookState);
}

class SaveNotebook {
  final url;
  final note;
  SaveNotebook({
    this.url,
    this.note
  });
}

 class UpdateNotebook {
  final index;
  final newNote;
  UpdateNotebook(
    this.index,
    this.newNote,
  );
}

 class DeleteNotebook {
  final index;
  DeleteNotebook(
    this.index,
  );
}

 class ReOrderNotebook {
  final oldIndex;
  final newIndex;
  ReOrderNotebook(
    this.oldIndex,
    this.newIndex,
  );
}
