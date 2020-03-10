import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'PlatformWidget.dart';

class PlatformTextField extends PlatformWidget<CupertinoTextField, TextField> {
  final TextEditingController controller;

  PlatformTextField({
    this.controller
  });

  @override 
  CupertinoTextField createIosWidget(BuildContext context) =>  CupertinoTextField(
    textAlign: TextAlign.start,
    controller: controller,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    autofocus: true,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.blue)
      ),
    ),
  );

  @override
  TextField createAndroidWidget(BuildContext context) =>  TextField(
    textAlign: TextAlign.start,
    controller: controller,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    autofocus: true,
    decoration:  InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ), 
    ),
  );
}
