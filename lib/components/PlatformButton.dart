import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'PlatformWidget.dart';

class PlatformButton extends PlatformWidget<CupertinoButton,FlatButton> {
  final Widget child;
  final Color color;
  final Function() onPressed;

  PlatformButton({
    this.child,
    this.color,
    this.onPressed
  });

  @override 
  CupertinoButton createIosWidget(BuildContext context) =>  CupertinoButton (
    child: child,
    color: color,
    onPressed: onPressed,
  );

  @override
  FlatButton createAndroidWidget(BuildContext context) =>  FlatButton(
    child: child,
    color: Colors.blue,
    textColor: Colors.white,
    disabledColor: Colors.grey,
    disabledTextColor: Colors.black,
    padding: EdgeInsets.all(8.0),
    splashColor: Colors.blueAccent,
    onPressed: onPressed,
  );
}