import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecosystem/constants.dart';

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    systemOverlayStyle:
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
    title: Text(title),
    centerTitle: true,
    backgroundColor: colorPrimary,
    leading: Builder(
      builder: (context) => IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: SvgPicture.asset("assets/images/menu.svg"),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
  );
}
