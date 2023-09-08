
import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';

Container getScreenHeader(String headerText, Size parentSize) {
  return Container(
    padding: headerPadding,
    height: parentSize.height * 0.3,
    width: parentSize.width,
    decoration: const BoxDecoration(
      color: colorPrimary,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(36),
        bottomRight: Radius.circular(36),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          headerText,
          style: headerStyle,
        ),
      ],
    ),
  );
}