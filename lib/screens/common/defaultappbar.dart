import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecosystem/constants.dart';

AppBar buildAppBar(BuildContext context, String? text) {
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
    const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
    backgroundColor: colorBackground,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: colorPrimary),
      onPressed: () => Navigator.of(context).maybePop(),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    )
  );
}
