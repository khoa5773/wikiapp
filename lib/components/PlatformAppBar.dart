import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'PlatformWidget.dart';

class PlatformAppBar extends PlatformWidget<ObstructingPreferredSizeWidget, PreferredSizeWidget> implements ObstructingPreferredSizeWidget {
  final Widget leading;
  final Widget title;
  final List<Widget> actions;
  final Color color;
  final Widget widget;

  PlatformAppBar({
    this.leading,
    this.title,
    this.actions,
    this.color,
    this.widget
  });

  @override
  Size get preferredSize {
    return  Size.fromHeight(20.0);
  }

  @override 
  CupertinoNavigationBar createIosWidget(BuildContext context) =>  CupertinoNavigationBar (
    leading: leading,
    middle: title,
    backgroundColor: color,
    trailing: widget,
  );

  @override
  AppBar createAndroidWidget(BuildContext context) =>  AppBar(
    leading: leading,
    title: title,
    actions: actions,
    centerTitle: true,
    backgroundColor: color,
    flexibleSpace: widget,
  );

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
