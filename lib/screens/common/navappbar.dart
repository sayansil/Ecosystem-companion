import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';

AppBar buildNavAppBar(BuildContext context, String? text) {
  return AppBar(
    elevation: 0,
    centerTitle: false,
    automaticallyImplyLeading: false,
    title: text == null ? null : Container(
        padding: const EdgeInsets.only(
            bottom: defaultPadding / 1.25,
            top: defaultPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                text,
                style: headerStyle,
              ),
            ),
          ],
        )
    ),
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
