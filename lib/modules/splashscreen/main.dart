import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wikiapp/modules/notebook/redux/action.dart';
import 'package:wikiapp/modules/read/redux/action.dart';
import 'package:wikiapp/redux/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final app = prefs.get('app');
    if (app == null) {
      await Future.delayed(Duration(seconds: 3));
    }
    if (app != null) {
      List<Future> futures = [
        persistor.load(),
        Future.delayed(Duration(seconds: 3))
      ];
      final initialState = await Future.wait(futures);
      store.dispatch(LoadReadState(initialState[0].readState));
      store.dispatch(LoadNoteBookState(initialState[0].notebookState));
    }
    return onDoneLoading();
  }

  onDoneLoading() async {
    Navigator.pushReplacementNamed(context, '/graph', arguments: null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/splash.jpg'), fit: BoxFit.cover),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        ),
      ),
    );
  }
}
