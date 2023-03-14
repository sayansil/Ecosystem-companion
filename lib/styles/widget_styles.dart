import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';

// * Global widget styles for application

const headerStyle = TextStyle(fontSize: 30, height: 0.9, fontFamily: 'Poppins', fontWeight: FontWeight.w300);
const headerPadding = EdgeInsets.only(
  left: defaultPadding,
  right: defaultPadding,
  top: defaultSmallPadding,
);

const editTextStyle = TextStyle(color: colorTextDark, fontSize: 18, fontFamily: 'Poppins');
const editTextDarkStyle = TextStyle(color: colorTextLight, fontSize: 18, fontFamily: 'Poppins');

const buttonStyle = TextStyle(fontSize: 16, height: 1.1, fontFamily: 'Poppins');
const bigButtonStyle = TextStyle(fontSize: 20, height: 1.1, fontFamily: 'Poppins');

const progressTextStyle = TextStyle(fontSize: 28, fontFamily: 'Poppins', color: colorSecondary);

const dialogTitleStyle = TextStyle(color: colorPrimary, fontSize: 18, fontFamily: 'Poppins');
const dialogSubtitleStyle = TextStyle(color: colorSecondary, fontSize: 15, fontFamily: 'Poppins');
const dialogButtonStyle = TextStyle(fontSize: 15, fontFamily: 'Poppins');

const snackBarTextStyle = TextStyle(fontSize: 15, fontFamily: 'Poppins');

const dropdownOptionStyle = TextStyle(fontSize: 18, fontFamily: 'Poppins', color: colorSecondary);

const chartTooltipTextStyle = TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.bold);