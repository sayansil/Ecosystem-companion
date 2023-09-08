import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/common/header.dart';
import 'package:ecosystem/styles/widget_styles.dart';

import 'package:flutter/material.dart';

class AboutBody extends StatefulWidget {
  const AboutBody({super.key});

  @override
  _AboutBodyState createState() => _AboutBodyState();
}

class _AboutBodyState extends State<AboutBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          // * Header bar
          getScreenHeader("About", size),

          Container(
            margin: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: size.height * 0.3 + 160,
            ),
            child:  const Text(
              stayTunedText,
              style: subHeaderStyle,
            ),
          )
        ],
      ),
    );
  }
}
