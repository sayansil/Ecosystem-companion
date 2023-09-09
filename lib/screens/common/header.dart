
import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';

Container getScreenHeaderText(String headerText) {
  return Container(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              headerText,
              style: headerStyle,
            ),
          ),
        ],
      )
  );
}

Container getScreenHeaderBackground(Size parentSize) {
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
  );
}