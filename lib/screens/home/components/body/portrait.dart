

import 'package:flutter/material.dart';

import 'dart:math';

import 'package:ecosystem/screens/common/header.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../../common/simulation_item.dart';

import 'driver.dart';

Widget getPortraitBody(HomeBodyState state) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: maskPadding,
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      child: Lottie.asset(
                        assetHappyDog,
                        animate: true,
                        repeat: true,
                        height: min(200, size.width / 8),
                        width: min(200, size.width / 8),
                      )
                    ),

                    Stack(
                      children: [
                        // Light grey background
                        Container(
                            constraints: BoxConstraints(
                                maxWidth: min(600, size.width)
                            ),
                            margin: const EdgeInsets.only(top: 20),
                            height: 200,
                            decoration: const BoxDecoration(
                              color: colorPrimaryLight,
                            )
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // * Form 1
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: min(600, size.width)
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                              decoration: const BoxDecoration(
                                color: colorPrimaryLight,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                boxShadow: defaultCardShadow,
                              ),
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white.withOpacity(0.8)),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  labelText: "Years to Simulate",
                                  labelStyle: editTextDarkStyle,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                controller: state.textYearsController,
                                onChanged: (String? text) {
                                  state.years = int.tryParse(state.textYearsController.text) ?? 0;
                                  state.simulationConfigChanged();
                                },
                              ),
                            ),

                            // * Form 2
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: min(600, size.width)
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
                                    DropdownButtonFormField<String>(
                                      icon: const Icon(Icons.arrow_downward_rounded),
                                      elevation: 20,
                                      style: dropdownOptionStyle,
                                      onChanged: (String? item) {
                                        if (item != null && item.isNotEmpty) {
                                          state.kingdomName = item;
                                          state.configChanged();
                                          state.fetchSpeciesList(state.kingdomName);
                                        }
                                      },
                                      items: state.kingdomList.map((e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      )).toList(),
                                      decoration: const InputDecoration(
                                        labelText: simulationKingdomInputText,
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
                                    DropdownButtonFormField<String>(
                                      icon: const Icon(Icons.arrow_downward_rounded),
                                      elevation: 20,
                                      style: dropdownOptionStyle,
                                      onChanged: (String? item) {
                                        if (item != null && item.isNotEmpty) {
                                          state.speciesName = item;
                                          state.configChanged();
                                        }
                                      },
                                      items: state.speciesList.map((e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      )).toList(),
                                      decoration: const InputDecoration(
                                        labelText: simulationKindInputText,
                                        labelStyle: editTextStyle,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),

                                    const Divider(
                                      height: 0,
                                      thickness: 1,
                                    ),

                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[

                                          // Age input
                                          Flexible(
                                            child: TextField(
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                              ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly
                                              ],
                                              decoration: InputDecoration(
                                                  labelText: "Age",
                                                  labelStyle: editTextStyle,
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  errorText:
                                                  state.textAgeController.text.isNotEmpty &&
                                                      !state.isValidNumber(state.textAgeController) ?
                                                  "Invalid value" : null
                                              ),
                                              controller: state.textAgeController,
                                              onChanged: (text) {state.configChanged();},
                                            ),
                                          ),


                                          // Count input
                                          Flexible(
                                            child: TextField(
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                              ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly
                                              ],
                                              decoration: InputDecoration(
                                                  labelText: "Count",
                                                  labelStyle: editTextStyle,
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  errorText:
                                                  state.textCountController.text.isNotEmpty &&
                                                      !state.isValidNumber(state.textCountController) ?
                                                  "Invalid value" : null
                                              ),
                                              controller: state.textCountController,
                                              onChanged: (text) {state.configChanged();},
                                            ),
                                          )
                                        ]),

                                    // Add set button
                                    ElevatedButton(
                                      onPressed: state.isSetReady
                                          ? () {
                                        state.addSet();
                                      }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorPrimary,
                                        foregroundColor: Colors.white,
                                        textStyle: buttonStyle,
                                        minimumSize: const Size(double.infinity, 30),
                                        shape: const StadiumBorder(),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: defaultPadding / 1.5),
                                      ),
                                      child: const Text(addSpeciesBtn),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // * Card List of selected Species
                    Flexible(
                      child: SizedBox(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 40, bottom: size.height * 0.3),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                          itemCount: state.allSets.isNotEmpty ? state.allSets.length + 1 : 0,
                          itemBuilder: (BuildContext context, index) {
                            return index < state.allSets.length ? speciesSetItem(
                                state.allSets[index].kingdom,
                                state.allSets[index].species,
                                state.allSets[index].age,
                                state.allSets[index].count
                            ) : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: defaultCardShadow,
                                  borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                color: colorSecondary,
                                iconSize: 35,
                                onPressed: () {
                                  state.clearSets();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
          ),


          //* Bottom Submit Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                disabledBackgroundColor: colorSecondary.withOpacity(.9),
                disabledForegroundColor: Colors.white54,
                textStyle: bigButtonStyle,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // <-- Radius
                ),
                padding: const EdgeInsets.symmetric(vertical: defaultPadding / 1.5),
              ),
              onPressed: state.isSimulationReady ? () {
                state.simulate();
              } : null,
              child: const Text(simulateBtn),
            ),
          ),
        ],
      ));
}