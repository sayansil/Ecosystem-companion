import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';

class BodyHeader extends StatelessWidget {
  final Size parentSize;

  const BodyHeader({Key? key, required this.parentSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: headerPadding,
      height: parentSize.height * 0.3,
      decoration: const BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "New Species",
            style: headerStyle,
          ),
        ],
      ),
    );
  }
}
