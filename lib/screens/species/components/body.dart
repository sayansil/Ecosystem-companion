import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';

import 'header.dart';
import 'package:flutter/material.dart';

class SpeciesBody extends StatefulWidget {
  @override
  _SpeciesBodyState createState() => _SpeciesBodyState();
}

class _SpeciesBodyState extends State<SpeciesBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          // * Header bar
          BodyHeader(parentSize: size),

          // * Bottom Submit Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                textStyle: bigButtonStyle,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.symmetric(vertical: defaultPadding / 1.5),
              ),
              onPressed: () {},
              child: const Text(addSpeciesBtn),
            ),
          ),
        ],
      ),
    );
  }
}
