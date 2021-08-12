import 'package:ecosystem/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(context),
      );

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: colorPrimary,
      title: Text("Settings"),
      brightness: Brightness.dark,
    );
  }
}
