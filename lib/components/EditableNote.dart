import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'PlatformWidget.dart';

class EditableNote extends PlatformWidget<CupertinoAlertDialog, AlertDialog> {
  final Widget textField;
  final List actions;

  EditableNote({
    this.textField,
    this.actions,
  });

  @override
  CupertinoAlertDialog createIosWidget(BuildContext context) =>
     CupertinoAlertDialog(
      title: Center(child:  Text('Edit notebook')),
      content: textField,
      actions: actions,
    );

  @override
  AlertDialog createAndroidWidget(BuildContext context) =>  AlertDialog(
    title: Center(child:  Text('Edit notebook')),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0))
    ),
    content: textField,
    actions: actions,
  );
}
