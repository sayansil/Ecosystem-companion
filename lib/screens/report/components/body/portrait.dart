import 'package:ecosystem/screens/common/dropdown.dart';
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
          child: Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Lottie.asset(assetLoading),
          )
      ),

      Visibility(
          visible: !state.loading,
          child: Column(
              children: [
                // Actions Bar
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(right: defaultPadding / 2),
                            child: getDropDown(
                              (String? item) => state.setActiveSpecies(item),
                              state.allSpecies,
                              "Species",
                              state.activeSpecies,
                            ),
                          ),
                        ),

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
                ),

                const SizedBox(height: defaultPadding),

                if (state.renderObjects != null)
                  Expanded(
                      child: Scrollbar(
                        interactive: true,
                        thumbVisibility: true,
                        child: state.getPlotList(size),
                      )
                  )
              ]
          )
      )
    ],
  );
}