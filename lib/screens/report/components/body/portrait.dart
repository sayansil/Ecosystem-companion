import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants.dart';
import '../../../../styles/widget_styles.dart';
import 'driver.dart';

Widget getPortraitBody(ReportBodyState state) {
  Size size = MediaQuery.of(state.context).size;

  return Stack(
    alignment: Alignment.center,
    children: [
      Visibility(
          visible: state.loading,
          child: Lottie.asset(assetLoading)
      ),

      Visibility(
          visible: !state.loading,
          child: Stack(
              children: [

                // Title
                const Positioned(
                    left: defaultPadding,
                    child: Text(
                      "Simulation\nReport",
                      style: hugeHeaderStyle,
                    )
                ),

                // Actions Bar
                Positioned(
                    right: defaultPadding,
                    top: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [

                            // Export button
                            ElevatedButton(
                              onPressed: null,
                              style: menuButtonStyle,
                              child: const Text("Export"),
                            ),


                            const SizedBox(
                              width: 15,
                            ),

                            // Save button
                            ElevatedButton(
                              onPressed: () {
                                state.saveData(state.context).then((value) => ScaffoldMessenger.of(state.context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(snackBarSavedReportText),
                                )));
                              },
                              style: menuButtonStyle,
                              child: const Text("Save"),
                            ),
                          ],
                        ),

                        // Species dropdown
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: DropdownButtonFormField<String>(
                                  icon: const Icon(Icons.arrow_downward_rounded),
                                  elevation: 10,
                                  style: dropdownOptionStyle,
                                  onChanged: (String? item) =>
                                      state.setActiveSpecies(item),
                                  value: state.activeSpecies,
                                  items: state.plotBundle?.plotGroups!.map((item) => DropdownMenuItem<String>(
                                    value: item.name!,
                                    child: Text(item.name!),
                                  )).toList(),
                                  decoration: const InputDecoration(
                                    labelText: "Species",
                                    labelStyle: editTextStyle,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  )
                              ),
                            )
                          ],
                        )
                      ],
                    )
                ),


                if (state.renderObjects != null)
                  Column(
                    children: [
                      const SizedBox(height: 150),
                      state.getPlotList(size),
                    ],
                  )
              ]
          )
      )
    ],
  );
}