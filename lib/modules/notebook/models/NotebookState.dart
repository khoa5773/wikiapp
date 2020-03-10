class Note {
  String url;
  String note;

  Note({
    this.note,
    this.url,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      note: json['note'] as String,
      url: json['url'] as String,
    );
  }
}

class NotebookState {
  List<Note> notes;

  NotebookState({
    this.notes
  });

  factory NotebookState.initial() {
    return  NotebookState(
      notes: []
    );
  }

  NotebookState copyWith({
    List<Note> notes
  }){
    return  NotebookState(
      notes: notes ?? this.notes,
    );
  }

  static NotebookState fromJson(dynamic json) =>
      NotebookState(
        notes: json,
      );

  dynamic toJson() {
    var res = [];
    for (var note in notes) {
      res.add({
        'url': note.url,
        'note': note.note
      });
    }
    return res;
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is NotebookState &&
        runtimeType == other.runtimeType &&
        notes == other.notes;

  @override
  int get hashCode =>
    notes.hashCode;
}