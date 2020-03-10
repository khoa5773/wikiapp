import 'package:wikiapp/modules/notebook/redux/reducer.dart';
import 'package:wikiapp/modules/read/redux/reducer.dart';

import './IStore.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    readState: readReducer(state.readState, action),
    notebookState: notebookReducer(state.notebookState, action),
  );
}
