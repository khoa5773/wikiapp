import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'PlatformWidget.dart';

class PlatformTabBar extends PlatformWidget<CupertinoTabBar, BottomNavigationBar> implements PreferredSizeWidget {
  final tabItems = [
    BottomNavigationBarItem(backgroundColor: Colors.brown[100], title: Text('Graph', style: TextStyle(fontWeight: FontWeight.bold),), icon: Icon(CupertinoIcons.eye_solid, color: Colors.grey[850],), activeIcon: Icon(CupertinoIcons.eye_solid)),
    BottomNavigationBarItem(
        backgroundColor: Colors.brown[100], title: Text('Notebook', style: TextStyle(fontWeight: FontWeight.bold)), icon: Icon(CupertinoIcons.bookmark_solid, color: Colors.grey[850]), activeIcon: Icon(CupertinoIcons.bookmark_solid)),
    BottomNavigationBarItem(backgroundColor: Colors.brown[100], title: Text('History', style: TextStyle(fontWeight: FontWeight.bold)), icon: Icon(CupertinoIcons.time_solid, color: Colors.grey[850]), activeIcon: Icon(CupertinoIcons.time_solid)),
    BottomNavigationBarItem(
        backgroundColor: Colors.brown[100], title: Text('Read', style: TextStyle(fontWeight: FontWeight.bold)), icon: Icon(CupertinoIcons.news_solid, color: Colors.grey[850]), activeIcon: Icon(CupertinoIcons.news_solid)),
  ];
  final Function(int) onTap;
  final int currentIndex;

  PlatformTabBar({this.onTap, this.currentIndex});

  @override
  CupertinoTabBar createIosWidget(BuildContext context) =>  CupertinoTabBar(
        items: tabItems,
        onTap: onTap,
        currentIndex: currentIndex,
        activeColor: Colors.pink,
        backgroundColor: Colors.brown,
      );

  @override
  BottomNavigationBar createAndroidWidget(BuildContext context) =>
       BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: tabItems,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.pink,
        backgroundColor: Colors.brown,
        elevation: 10,
      );

  @override
  Size get preferredSize => null;
}
