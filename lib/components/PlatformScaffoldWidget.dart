import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wikiapp/helpers/randomUrl.dart';
import 'PlatformTabBar.dart';
import 'PlatformWidget.dart';

class PlatformScaffoldWidget
    extends PlatformWidget<CupertinoTabScaffold, Scaffold> {
  final Color color;
  final Widget child;
  final PlatformTabBar bottomNavigationBar;
  final String appBartitle;

  PlatformScaffoldWidget({
    this.color,
    this.child,
    this.bottomNavigationBar,
    this.appBartitle,
  });

  @override
  CupertinoTabScaffold createIosWidget(BuildContext context) =>
       CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: bottomNavigationBar.tabItems,
          onTap: bottomNavigationBar.onTap,
          currentIndex: bottomNavigationBar.currentIndex,
          activeColor: Colors.blueAccent[400],
        ),
        backgroundColor: color,
        tabBuilder: (context, index) {
          return child;
        },
      );

  @override
  Scaffold createAndroidWidget(BuildContext context) =>  Scaffold(
        appBar: AppBar(
          title:  Center(
            child:  Text(
              appBartitle ?? 'Title',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: color,
        body: child,
        bottomNavigationBar: bottomNavigationBar,
        drawer: Drawer(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                title: Text('Graph Page', style: TextStyle(fontSize: 25, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),),
                trailing: Icon(CupertinoIcons.eye_solid, size: 30, color: Colors.redAccent,),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/graph', arguments: null);
                },
              ),
              Divider(),
              ListTile(
                title: Text('Read Page', style: TextStyle(fontSize: 25, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                trailing: Icon(CupertinoIcons.news_solid, size: 30, color: Colors.redAccent,),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/read', arguments: randomUrl());
                },
              ),
              Divider(),
              ListTile(
                title: Text('History Page', style: TextStyle(fontSize: 25, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                trailing: Icon(CupertinoIcons.time_solid, size: 30, color: Colors.redAccent,),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/history');
                },
              ),
              Divider(),
              ListTile(
                title: Text('Notebook Page', style: TextStyle(fontSize: 25, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                trailing: Icon(CupertinoIcons.bookmark_solid, size: 30, color: Colors.redAccent,),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/notebook');
                },
              ),
            ],
          ),
        ),
      );
}
