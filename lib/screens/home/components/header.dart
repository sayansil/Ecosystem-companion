import 'package:ecosystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/styles/widget_styles.dart';

class BodyHeader extends StatelessWidget {
  final Size parentSize;

  BodyHeader({Key? key, required this.parentSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        bottom: defaultPadding + 200,
      ),
      height: parentSize.height * 0.3,
      decoration: BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            "Ecosystem Simulator",
            style: headerStyle,
          ),
        ],
      ),
    );
  }
}
