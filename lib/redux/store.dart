import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';
import './IStore.dart';
import './reducers.dart';

final persistor = Persistor<AppState>(
      storage: FlutterStorage(location: FlutterSaveLocation.sharedPreferences),
      serializer: JsonSerializer<AppState>(AppState.fromJson),
      throttleDuration: Duration(seconds: 2),
      shouldSave: (state, _) => true,
    );

final store = Store<AppState>(
  appStateReducer,
  initialState:  AppState.initial(),
  middleware: [thunkMiddleware, persistor.createMiddleware()],
);
