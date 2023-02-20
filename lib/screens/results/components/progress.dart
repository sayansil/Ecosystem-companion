import 'dart:math';

import 'package:ecosystem/styles/widget_styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';

class ResultProgress extends StatefulWidget {
  final int years;
  final List<SimulationSet> initOrganisms;

  ResultProgress(this.years, this.initOrganisms, {Key? key}): super(key: key);

  @override
  _ResultProgressState createState() => _ResultProgressState();
}

class _ResultProgressState extends State<ResultProgress> {
  int currentYear = 0;
  int population = 0;
  var simulationState = SimulationStatus.ready;

  String getProgressText() {
    return currentYear.toString() + " / " + widget.years.toString() + "\nyears";
  }

  Future<int> iterateSimulation() async {
    await new Future.delayed(const Duration(seconds: 1)); // heavy task

    return 10; // Current overall population
  }

  Future<void> startSimulation() async {
    setState(() {
      simulationState = SimulationStatus.running;
    });

    // Init simulation

    while(mounted && currentYear < widget.years && simulationState == SimulationStatus.running) {
      // Iterate simulation
      int _population = await iterateSimulation();

      if (mounted) { // Update states
        setState(() {
          population = _population;
          currentYear = currentYear + 1;
        });
      }
    }

    // Mark the simulation complete if it ran till end
    if (mounted && simulationState == SimulationStatus.running) {
      setState(() {
        simulationState = SimulationStatus.completed;
      });
    } // Else it was stopped prematurely
  }

  Future<void> stopSimulation() async {
    setState(() {
      simulationState = SimulationStatus.stopped;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size parentSize = MediaQuery.of(context).size;

    double progressDims = min(parentSize.width * 0.75, 500);
    double markerWidth = progressDims * 0.1;

    return Container(

      child: Stack(
        children: <Widget>[
          // Progress bar
          Container(
            alignment: Alignment.topCenter,
            child: Container(
                height: progressDims,
                width: progressDims,
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: AxisLineStyle(
                        thickness: markerWidth,
                        cornerStyle: CornerStyle.bothCurve,
                        color: colorSecondaryLight,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: max(100 * currentYear.toDouble() / widget.years, 10),
                          cornerStyle: CornerStyle.bothCurve,
                          width: markerWidth,
                          color: colorPrimaryLight,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            positionFactor: 0.1,
                            angle: 90,
                            widget: Text(
                              getProgressText(),
                              style: progressTextStyle,
                            ))
                      ])
                ])
            ),

          ),

          // Start button
          Positioned(
            left: 0,
            right: 0,
            top: progressDims,

            child: Visibility(
              visible: simulationState == SimulationStatus.ready,
              child: Container(
                padding: EdgeInsets.only(
                  left: parentSize.width * 0.3,
                  right: parentSize.width * 0.3,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary,
                    textStyle: bigButtonStyle,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // <-- Radius
                    ),
                    padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  ),
                  onPressed: startSimulation,
                  child: const Text(simulateStartBtn),
                ),
              )
            )
          ),

          // Stop button
          Positioned(
              left: 0,
              right: 0,
              top: progressDims,

              child: Visibility(
                  visible: simulationState != SimulationStatus.ready,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: parentSize.width * 0.3,
                      right: parentSize.width * 0.3,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        textStyle: bigButtonStyle,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // <-- Radius
                        ),
                        padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                      ),
                      onPressed: simulationState == SimulationStatus.running ? () {
                        stopSimulation();
                      } : null,
                      child: const Text(simulateStopBtn),
                    ),
                  )
              )
          ),

        ],
      )
    );
  }
}
