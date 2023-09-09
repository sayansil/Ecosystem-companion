import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/common/header.dart';
import 'package:ecosystem/styles/widget_styles.dart';

import 'package:flutter/material.dart';

class AboutBody extends StatefulWidget {
  const AboutBody({super.key});

  @override
  State<AboutBody> createState() => _AboutBodyState();
}

class _AboutBodyState extends State<AboutBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          // * Header background
          getScreenHeaderBackground(size),

          Container(
            padding: const EdgeInsets.only(
              top: defaultPadding,
              left: defaultPadding,
              right: defaultPadding,
            ),
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                  // Title
                  getScreenHeaderText("About"),

                  // TODO
              ]
            ),
          ),

          Positioned(
            bottom: 50,
            child: Container(
              margin: const EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                bottom: 50,
              ),
              child:  const Text(
                stayTunedText,
                style: subHeaderStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
