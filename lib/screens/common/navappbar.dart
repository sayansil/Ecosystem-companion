import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecosystem/constants.dart';

AppBar buildNavAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    systemOverlayStyle:
        const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
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
