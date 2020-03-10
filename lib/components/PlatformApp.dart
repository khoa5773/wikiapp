import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wikiapp/routers/routers.dart';
import 'PlatformWidget.dart';

class PlatformApp extends PlatformWidget<CupertinoApp, MaterialApp> {
  final Widget home;
  final ThemeData materialTheme;
  final CupertinoThemeData cupertinoTheme;
  final String title;
  final GlobalKey<NavigatorState> navKey;

  PlatformApp(
      {this.home,
      this.materialTheme,
      this.cupertinoTheme,
      this.title,
      this.navKey});

  @override
  CupertinoApp createIosWidget(BuildContext context) =>  CupertinoApp(
        home: home,
        onGenerateRoute: onGenerateRoute,
        theme: cupertinoTheme,
        title: title,
        navigatorKey: navKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const <LocalizationsDelegate>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      );

  @override
  MaterialApp createAndroidWidget(BuildContext context) =>  MaterialApp(
        home: home,
        onGenerateRoute: onGenerateRoute,
        theme: materialTheme,
        title: title,
        navigatorKey: navKey,
        debugShowCheckedModeBanner: false,
      );
}
