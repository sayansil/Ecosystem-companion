import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';

Container speciesSetItem(kingdom, species, age, count) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)),
    child: Stack(children: <Widget>[
      Positioned(
        top: 10,
        left: 15,
        right: 15,
        child: Text(
          species,
          style: homeCardKindTextStyle,
        ),
      ),
      Positioned(
        top: 45,
        left: 15,
        right: 15,
        child: Text(
          kingdom,
          style: homeCardKingdomTextStyle,
        ),
      ),
      Positioned(
        bottom: 13,
        left: 15,
        right: 15,
        child: Text(
          "$age year${ age > 1 ? 's' : ''}",
          style: homeCardAgeTextStyle,
        ),
      ),
      Positioned(
        bottom: 10,
        right: 15,
        child: Text(
          count.toString(),
          style: homeCardCountTextStyle,
        ),
      ),
    ]),
  );
}