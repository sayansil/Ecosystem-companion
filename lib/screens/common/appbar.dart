import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    brightness: Brightness.dark,
    title: Text(title),
    centerTitle: true,
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
