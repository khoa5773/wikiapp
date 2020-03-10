import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wikiapp/components/PlatformButton.dart';
import 'package:wikiapp/components/EditableNote.dart';
import 'package:wikiapp/components/PlatformScaffoldWidget.dart';
import 'package:wikiapp/components/PlatformTextField.dart';
import 'package:wikiapp/modules/notebook/models/NotebookState.dart';
import 'package:wikiapp/components/PlatformTabBar.dart';
import 'package:wikiapp/modules/notebook/redux/action.dart';
import 'package:wikiapp/helpers/randomUrl.dart';
import 'package:wikiapp/redux/IStore.dart';
import 'package:wikiapp/routers/routers.dart';
import 'package:reorderables/reorderables.dart';

class _ViewModel {
  final notebookState;
  final updateNoteBook;
  final deleteNoteBook;
  final reorderNoteBook;
  _ViewModel({
    @required this.notebookState,
    @required this.updateNoteBook,
    @required this.deleteNoteBook,
    @required this.reorderNoteBook,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          notebookState == other.notebookState;

  @override
  int get hashCode => notebookState.hashCode;
}

class NotebookPage extends StatefulWidget {
  @override
  _NotebookState createState() => _NotebookState();
}

class _NotebookState extends State<NotebookPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {},
      distinct: true,
      converter: (store) {
        return  _ViewModel(
          notebookState: store.state.notebookState,
          updateNoteBook: (index, newNote) =>
              store.dispatch(UpdateNotebook(index, newNote)),
          deleteNoteBook: (index) => store.dispatch(DeleteNotebook(index)),
          reorderNoteBook: (oldIndex, newIndex) =>
              store.dispatch(ReOrderNotebook(oldIndex, newIndex)),
        );
      },
      builder: (context, viewModel) {
        final List<Note> notes = viewModel.notebookState.notes;

        return PlatformScaffoldWidget(
          appBartitle: "Notebook",
          bottomNavigationBar: PlatformTabBar(
            onTap: (index) {
              if (index == 3) {
                Navigator.pushReplacementNamed(context, routes[index], arguments: randomUrl());
                return ;
              }
              if (index != 1) {
                Navigator.pushReplacementNamed(context, routes[index]);
              }
            },
            currentIndex: 1,
          ),
          child: SingleChildScrollView(child: SafeArea(child: Column(children: <Widget>[
            Align(
              child: Padding(
                child:  Text("*Note: To reorder please click and hold then move", style: TextStyle(fontSize: 20, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                padding: EdgeInsets.only(left: 10.0, top: 10.0),
              ),
              alignment: Alignment.bottomLeft,
            ),
            Divider(color: Colors.cyan, thickness: 5,),
            Container(
              margin: EdgeInsets.all(10.0),
              child: ReorderableColumn(
                scrollController: ScrollController(),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(notes.length, (index) {
                  final eachNote = notes[index];
                  return Container(
                    key: ValueKey("value$index"),
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(child: 
                      Column(children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft, 
                          child:  Text(
                            'URL:${eachNote.url}', 
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.blueAccent[400], 
                            fontWeight: FontWeight.bold, 
                            fontSize: 12.0
                          ))),
                        Align(
                          alignment: Alignment.bottomLeft, 
                          child: Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child:  Text(
                            'Note:${eachNote.note}', 
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600], 
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                            )))),
                        Divider(color: Colors.cyanAccent,)
                      ]),),
                      Material(child:OptionButton(note: eachNote, viewModel: viewModel, index: index))
                    ],
                  ),
                  );
                }),
                onReorder: (int oldIndex, int newIndex) {
                  viewModel.reorderNoteBook(oldIndex, newIndex);
                },
              ),
            ),
          ],),
        )));
      },
    );
  }
}

class OptionButton extends StatefulWidget {
  final Note note;
  final _ViewModel viewModel;
  final int index;

  OptionButton(
      {Key key,
      @required this.note,
      @required this.viewModel,
      @required this.index})
      : super(key: key);

  @override
  _OptionButtonState createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.note.note);
  }

  _showDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return EditableNote(
            textField: Column(children: <Widget>[
              Align(
                child: Text(
                  'Note',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                alignment: Alignment.bottomLeft,
              ),
              Padding(
                  child: PlatformTextField(controller: _noteController),
                  padding: EdgeInsets.only(
                    bottom: 20.0,
                  )),
              Align(
                child: Text(
                  'URL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                alignment: Alignment.bottomLeft,
              ),
              Text(
                widget.note.url,
                textAlign: TextAlign.start,
              )
            ]),
            actions: <Widget>[
              PlatformButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              PlatformButton(
                child: Text('Save'),
                onPressed: () {
                  widget.viewModel
                      .updateNoteBook(widget.index, _noteController.text);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _showReadDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return EditableNote(
            textField: Column(children: <Widget>[
              Align(
                child: Text(
                  'Note',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                alignment: Alignment.bottomLeft,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    widget.note.note,
                    textAlign: TextAlign.start,
                ),
                  ),
              ) ,
              Align(
                child: Text(
                  'URL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                alignment: Alignment.bottomLeft,
              ),
              Text(
                widget.note.url,
                textAlign: TextAlign.start,
              )
            ]),
            actions: <Widget>[
              PlatformButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  onChangeValue(newValue, context) {
    if (newValue == 'Edit') {
      _showDialog(context);
    }

    if (newValue == 'View') {
      _showReadDialog(context);
    }

    if (newValue == 'Delete') {
      widget.viewModel.deleteNoteBook(widget.index);
    }

    if (newValue == 'Open') {
      Navigator.pushReplacementNamed(context, '/read',
          arguments: widget.note.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  DropdownButton<String>(
      underline: Container(
        height: 0,
      ),
      icon: Icon(Icons.more, color: Colors.indigoAccent),
      iconSize: 24,
      onChanged: (String newValue) {
        onChangeValue(newValue, context);
      },
      items: <String>['Open', 'View', 'Edit', 'Delete'].map((String value) {
        return  DropdownMenuItem<String>(
          value: value,
          child:  Text(value),
        );
      }).toList(),
    );
  }
}
