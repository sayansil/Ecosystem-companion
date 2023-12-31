
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/sample_species.dart';
import 'package:ecosystem/screens/common/header.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import '../../../common/species_item.dart';
import 'driver.dart';

Widget getPortraitBody(SpeciesBodyState state) {
  Size size = MediaQuery.of(state.context).size;

  return Container(
    constraints: const BoxConstraints.expand(),
    child: Stack(
      children: <Widget>[
        // * Header background
        getScreenHeaderBackground(size),

        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white.withOpacity(0.05)],
              stops: const [0.95, 1],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
            ),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: maskPadding,
                ),

                Container(
                  constraints: BoxConstraints(
                      maxWidth:max(600, size.width * 0.3)
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                    vertical: defaultPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: defaultCardShadow,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        // Kingdom input
                        DropdownButtonFormField<KingdomName>(
                          icon: const Icon(Icons.arrow_downward_rounded),
                          elevation: 20,
                          style: dropdownOptionStyle,
                          onChanged: (KingdomName? item) {
                            if (item != null) {
                              state.kingdomName = item.name;
                              state.configChanged();
                            }
                          },
                          items: KingdomName.values.map((KingdomName item) {
                            return DropdownMenuItem<KingdomName>(
                              value: item,
                              child: Text(item.name),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: configKingdomInputText,
                            labelStyle: editTextStyle,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),


                        const Divider(
                          height: 0,
                          thickness: 1,
                        ),

                        // Species input
                        TextField(
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                          decoration: const InputDecoration(
                            labelText: configKindInputText,
                            labelStyle: editTextStyle,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          controller: state.textKindController,
                          onChanged: (text) {state.configChanged();},
                        ),


                        const Divider(
                          height: 0,
                          thickness: 1,
                        ),


                        // Base Json file input
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                                decoration: const InputDecoration(
                                  labelText: speciesSelectBaseJsonPath,
                                  labelStyle: editTextStyle,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                controller: state.textBaseJsonPathController,
                              ),
                            ),

                            IconButton(
                              icon: Image.asset('assets/images/folder.png'),
                              iconSize: 30,
                              onPressed: () {state.fillPath(state.textBaseJsonPathController);},
                            )
                          ],
                        ),


                        const Divider(
                          height: 0,
                          thickness: 1,
                        ),


                        // Modify json file input
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                                decoration: const InputDecoration(
                                  labelText: speciesSelectModifyJsonPath,
                                  labelStyle: editTextStyle,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                controller: state.textModifyJsonPathController,
                              ),
                            ),

                            IconButton(
                              icon: Image.asset('assets/images/folder.png'),
                              iconSize: 30,
                              onPressed: () {state.fillPath(state.textModifyJsonPathController);},
                            )
                          ],
                        ),
                      ]),
                ),

                Container(
                  margin: const EdgeInsets.only(top: defaultPadding * 2),
                  child: const Text(
                    addSampleSpeciesHeader,
                    style: secondaryHeaderStyle,
                  ),
                ),

                Flexible(
                  child: SizedBox(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 20, bottom: size.height * 0.3),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 1,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: sampleSpeciesList.isNotEmpty ? sampleSpeciesList.length : 0,
                        itemBuilder: (BuildContext context, index) {
                          return InkWell(
                            child: sampleSpeciesItem(
                              sampleSpeciesList[index].kingdom,
                              sampleSpeciesList[index].name,
                            ),
                            onTap: () {
                              state.confirmFetchSpeciesData(sampleSpeciesList[index], context);
                            },
                          );
                        },
                      )
                  ),
                ),
              ],
            ),
          ),
        ),

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
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 1.5),
            ),
            onPressed: state.validSpecies ? () {
              state.createSpecies(state.context);
            } : null,
            child: const Text(addSpeciesBtn),
          ),
        ),
      ],
    ),
  );
}