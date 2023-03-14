import 'dart:math';

import 'package:ecosystem/schema/generated/world_ecosystem_generated.dart';
import 'package:ecosystem/screens/common/live_plot.dart';
import 'package:ecosystem/screens/common/transition.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:native_simulator/native_simulator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressBody extends StatefulWidget {
  final int years;
  final List<SimulationSet> initOrganisms;

  const ProgressBody(this.years, this.initOrganisms, {Key? key}): super(key: key);

  @override
  _ProgressBodyState createState() => _ProgressBodyState();
}

class _ProgressBodyState extends State<ProgressBody> {
  int currentYear = 0;
  int population = 0;

  List<int> x = [];
  List<int> y = [];

  SimulationStatus simulationState = SimulationStatus.ready;
  NativeSimulator simulator = NativeSimulator();

  @override
  void initState() {
    super.initState();
    prepareSimulation();
  }

  Future<void> prepareSimulation() async {
    x = [];
    y = [];

    final ecosystemRoot = await getEcosystemRoot();
    simulator.initSimulation(ecosystemRoot);

    for (var element in widget.initOrganisms) {
      simulator.createInitialOrganisms(
          getKingdomIndex(element.kingdom),
          element.species,
          element.age,
          element.count
      );
    }

    simulator.prepareWorld();
  }

  String getProgressText() {
    return "$currentYear / ${widget.years}";
  }

  Future<int> iterateSimulation() async {
    final fbList = simulator.simulateOneYear();
    final bufferSize = fbList.length;
    int currentPopulation = 0;

    var world = World(fbList);
    if (world.species != null) {
      for (var species in world.species!) {
        currentPopulation += species.organism!.length;
      }
    }

    await cap120fps();

    return currentPopulation;
  }

  Future<void> startSimulation() async {
    setState(() {
      simulationState = SimulationStatus.running;
    });

    while(mounted && currentYear < widget.years && simulationState == SimulationStatus.running) {
      // Iterate simulation
      int currentPopulation = await iterateSimulation();

      if (mounted) { // Update states
        setState(() {
          population = currentPopulation;
          currentYear = currentYear + 1;

          x.add(currentYear);
          y.add(population);
        });
      }
    }

    // Mark the simulation complete if it ran till end
    if (mounted && simulationState == SimulationStatus.running) {
      simulator.cleanup();

      setState(() {
        simulationState = SimulationStatus.completed;
      });
    } // Else it was stopped prematurely
  }

  Future<void> stopSimulation() async {
    simulator.cleanup();

    setState(() {
      simulationState = SimulationStatus.stopped;
    });
  }

  @override
  void dispose() {
    simulator.cleanup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size parentSize = MediaQuery.of(context).size;

    double progressDims = min(parentSize.width * 0.75, 500);
    double markerWidth = progressDims * 0.1;

    return Stack(
      children: <Widget>[

        // Progress bar
        Container(
          alignment: Alignment.topCenter,
          child: SizedBox(
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
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                ),
                onPressed: () async => startSimulation(),
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
                      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                    ),
                    onPressed: simulationState == SimulationStatus.running ? () {
                      stopSimulation();
                    } : null,
                    child: const Text(simulateStopBtn),
                  ),
                )
            )
        ),

        // Bottom Live Plot
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Visibility(
              visible: x.isNotEmpty,
              child:
                AspectRatio(
                  aspectRatio: 1,
                  child: LineChart(
                    liveData(x, y, widget.years.toDouble()),
                    swapAnimationDuration: const Duration(milliseconds: 8), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ),
                )
            )
        )
      ],
    );
  }
}
