import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecosystem/constants.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    systemOverlayStyle:
    SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
    backgroundColor: colorBackground,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: colorPrimary),
      onPressed: () => Navigator.of(context).maybePop(),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    )
  );
}
