import 'dart:developer';

import 'package:ecosystem/screens/common/dropdown.dart';
import 'package:ecosystem/screens/common/live_plot.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'driver.dart';

Widget getPortraitBody(ProgressBodyState state) {
  return Stack(
    children: <Widget>[
      // Bottom Live Plot
      Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Visibility(
              visible: state.x.isNotEmpty,
              child:
              AspectRatio(
                aspectRatio: 1,
                child: LineChart(
                  liveData(state.x, state.y, state.widget.years.toDouble()),
                  swapAnimationDuration: const Duration(milliseconds: 15), // Optional
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              )
          )
      ),

      // Title text
      const Positioned(
        left: defaultPadding,
        top: 0,
        child: Text(
          "Simulation",
          style: hugeHeaderStyle,
        ),
      ),

      // Subtitle Text
      Positioned(
        left: defaultPadding,
        top: 75,
        child: RichText(text: TextSpan(
            children: [
              const TextSpan(
                text: "year  ",
                style: subHeaderStyle,
              ),
              TextSpan(
                text: "${state.currentYear} / ${state.widget.years}",
                style: highlightedSubHeaderStyle,
              )
            ]
        )),
      ),

      // Start/Stop/View button
      Positioned(
        right: defaultPadding,
        top: 12.5,

        child: ElevatedButton(
          style: highlightMenuButtonStyle,
          onPressed: () async {
            if (state.simulationState == SimulationStatus.init) {
              return;
            } else if (state.simulationState == SimulationStatus.ready) {
              state.startSimulation();
            } else if (state.simulationState == SimulationStatus.running) {
              state.stopSimulation();
            } else if (state.simulationState == SimulationStatus.stopped ||
                state.simulationState == SimulationStatus.completed) {
              state.viewSimulation();
            }
          },
          child: Text(
              state.simulationState == SimulationStatus.ready ?
              simulateStartBtn :
              state.simulationState == SimulationStatus.running ?
              simulateStopBtn :
              state.simulationState == SimulationStatus.stopped ||
                  state.simulationState == SimulationStatus.completed ?
              simulateViewBtn : ""
          ),
        ),
      ),

      // Inputs
      Positioned(
        left: defaultPadding,
        right: defaultPadding,
        top: 125,
        child:
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              // Species input
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(right: defaultPadding / 2),
                  child: getDropDown(
                    state.selectSpecies,
                    state.allSpecies,
                    "Species",
                    state.activeSpecies,
                  ),
                ),
              ),


              // Attribute input
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(left: defaultPadding / 2),
                  child: getDropDown(
                    state.selectAttribute,
                    state.allAttributes,
                    "Attribute",
                    state.activeAttribute,
                  ),
                ),
              )
            ]),
      ),
    ],
  );
}