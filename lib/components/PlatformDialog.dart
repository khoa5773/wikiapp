import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wikiapp/components/PlatformButton.dart';
import 'PlatformWidget.dart';

class PlatformDialog extends PlatformWidget<CupertinoAlertDialog, AlertDialog> {
  final Function() onNoPressed;
  final Function() onYesPressed;
  final Widget title =
      Center(child:  Text('Do you want to save it with free text below?'));
  final Widget textField;

  PlatformDialog({
    this.onNoPressed,
    this.onYesPressed,
    this.textField
  });

  @override
  CupertinoAlertDialog createIosWidget(BuildContext context) =>
       CupertinoAlertDialog(
        title: title,
        content: textField,
        actions: [
          PlatformButton(
            child: Text('No'),
            onPressed: onNoPressed,
          ),
          PlatformButton(
            child: Text('Yes'),
            onPressed: onYesPressed,
          )
        ],
      );

  @override
  AlertDialog createAndroidWidget(BuildContext context) =>  AlertDialog(
        title: title,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        content: textField,
        actions: [
          PlatformButton(
            child: Text('No'),
            onPressed: onNoPressed,
          ),
          PlatformButton(
            child: Text('Yes'),
            onPressed: onYesPressed,
          )
        ],
      );
}
