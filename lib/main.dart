import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wikiapp/modules/splashscreen/main.dart';
import 'components/PlatformApp.dart';
import 'redux/store.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(WikiApp());
}

class WikiApp extends StatefulWidget {
  static final navKey =  GlobalKey<NavigatorState>();

  @override
  _WikiAppState createState() => _WikiAppState();
}

class _WikiAppState extends State<WikiApp> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: PlatformApp(
        home: SplashScreen(),
        title: 'Rabbit Hole',
        materialTheme:  ThemeData(
          scaffoldBackgroundColor: Colors.grey[50],
          fontFamily: 'Quicksand',
            primaryColor: Colors.pinkAccent),
        cupertinoTheme:  CupertinoThemeData(
          textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontFamily: 'Quicksand',)),
            primaryColor: Colors.pinkAccent),
        
        navKey: WikiApp.navKey,
      ));
  }
}
