import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';

// * Global widget styles for application

const headerStyle = TextStyle(fontSize: 30, height: 0.9, fontFamily: 'Poppins', fontWeight: FontWeight.w300);
const headerPadding = EdgeInsets.only(
  left: defaultPadding,
  right: defaultPadding,
  top: defaultSmallPadding,
);

const hugeHeaderStyle = TextStyle(fontSize: 35, fontFamily: 'Poppins', fontWeight: FontWeight.w500, color: colorPrimary, height: 1.75);

const editTextStyle = TextStyle(color: colorTextDark, fontSize: 18, fontFamily: 'Poppins');
const editTextDarkStyle = TextStyle(color: colorTextLight, fontSize: 18, fontFamily: 'Poppins');

const buttonStyle = TextStyle(fontSize: 16, height: 1.1, fontFamily: 'Poppins');
const smallButtonStyle = TextStyle(fontSize: 10, height: 0.9, fontFamily: 'Poppins');
const bigButtonStyle = TextStyle(fontSize: 20, height: 1.1, fontFamily: 'Poppins');

const progressTextStyle = TextStyle(fontSize: 28, fontFamily: 'Poppins', color: colorSecondary);

const plotLabelStyle = TextStyle(fontSize: 13, height: 0.9, fontFamily: 'Poppins');
const plotTickStyle = TextStyle(fontSize: 13, height: 0.9, fontFamily: 'Poppins', fontWeight: FontWeight.bold);
const plotTitleStyle = TextStyle(fontSize: 18, height: 0.9, fontFamily: 'Poppins');

const dialogTitleStyle = TextStyle(color: colorPrimary, fontSize: 18, fontFamily: 'Poppins');
const dialogSubtitleStyle = TextStyle(color: colorSecondary, fontSize: 15, fontFamily: 'Poppins');
const dialogButtonStyle = TextStyle(fontSize: 15, fontFamily: 'Poppins');

const snackBarTextStyle = TextStyle(fontSize: 15, fontFamily: 'Poppins');

const dropdownOptionStyle = TextStyle(fontSize: 18, fontFamily: 'Poppins', color: colorSecondary);

const chartTooltipTextStyle = TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.bold);

const homeCardKindTextStyle = TextStyle(fontSize: 30);
const homeCardKingdomTextStyle = TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontFamily: 'Poppins');
const homeCardAgeTextStyle = TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: colorTertiary, fontFamily: 'Poppins');
const homeCardCountTextStyle = TextStyle(fontSize: 30, fontFamily: 'Poppins');

const historyItemTitleTextStyle = TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.bold);
const historyItemSubtitleTextStyle = TextStyle(fontSize: 15, fontFamily: 'Poppins');

final menuButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: colorPrimary,
  foregroundColor: Colors.white,
  textStyle: smallButtonStyle,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))
  ),
);