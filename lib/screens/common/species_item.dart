import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:flutter/material.dart';

Container sampleSpeciesItem(KingdomName kingdom, String name) {
  return Container(
    decoration: BoxDecoration(
        color: kingdom == KingdomName.animal ? colorAnimalAccent : colorPlantAccent,
        boxShadow: defaultCardShadow,
        borderRadius: BorderRadius.circular(10)),
    child: Stack(
      children: <Widget>[
        Positioned(
          top: 10,
          left: 15,
          right: 15,
          child: Text(
            name,
            style: homeCardKindTextStyle,
          ),
        ),
        Positioned(
          top: 45,
          left: 15,
          right: 15,
          child: Text(
            kingdom.value,
            style: homeCardKingdomTextStyle,
          ),
        ),
      ]
    )
  );
}