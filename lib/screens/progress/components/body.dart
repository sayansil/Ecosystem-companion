import 'package:ecosystem/schema/world_ecosystem_generated.dart';
import 'package:ecosystem/screens/common/dropdown.dart';
import 'package:ecosystem/screens/common/live_plot.dart';
import 'package:ecosystem/screens/common/transition.dart';
import 'package:ecosystem/screens/report/report_screen.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/num_utils.dart';
import 'package:ecosystem/utility/report_helpers.dart';
import 'package:native_simulator/native_simulator.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:recase/recase.dart';

class ProgressBody extends StatefulWidget {
  final int years;
  final List<SimulationSet> initOrganisms;

  const ProgressBody(this.years, this.initOrganisms, {Key? key}): super(key: key);

  @override
  _ProgressBodyState createState() => _ProgressBodyState();
}

class _ProgressBodyState extends State<ProgressBody> {
  int currentYear = 0;

  List<double> x = [];
  List<double> y = [];

  String? activeSpecies;
  String? activeAttribute;

  Map<String, KingdomName> currentSpeciesKingdomMap = {};

  List<DropdownObject> allSpecies = [];
  List<DropdownObject> allAttributes = [];

  SimulationStatus simulationState = SimulationStatus.init;
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

    Set<String> allSpeciesSet = {};

    for (var element in widget.initOrganisms) {
      simulator.createInitialOrganisms(
          getKingdomIndex(element.kingdom),
          element.species,
          element.age,
          element.count
      );
      allSpeciesSet.add(element.species);
      currentSpeciesKingdomMap[element.species] = KingdomName.getByValue(element.kingdom);
    }

    simulator.prepareWorld();

    List<String> allAttributeValues = simulator.getAllAttributes();
    final allSpeciesValues = allSpeciesSet.toList();

    setState(() {
      allSpecies = allSpeciesValues.map((e) => DropdownObject.common(e)).toList();
      // TODO - allSpecies.add(DropdownObject.common(allSpeciesIdentifier));

      allAttributes = allAttributeValues.map(
              (e) => DropdownObject(e, e.titleCase)).toList();
      activeSpecies = allSpeciesValues[0];
      activeAttribute = defaultAttributeIdentifier;
    });

    simulationState = SimulationStatus.ready;
  }

  Future<void> iterateSimulation() async {
    simulator.simulateOneYear();
    simulator.saveWorldInstance();

    await cap120fps();
  }

  Future<void> startSimulation() async {
    setState(() {
      simulationState = SimulationStatus.running;
    });

    while(mounted && currentYear < widget.years && simulationState == SimulationStatus.running) {
      // Iterate simulation
      await iterateSimulation();

      if (mounted) { // Update states
        setState(() {
          currentYear = currentYear + 1;

          x.add(currentYear.toDouble());
          y = simulator.getPlotData(activeSpecies!, activeAttribute!);
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

  Future<void> viewSimulation() async {
    Navigator.push(context, buildPageRoute(const ReportScreen(null)));
  }

  void selectSpecies(String? value) {
    setState(() {
      activeSpecies = value;

      if (simulationState == SimulationStatus.stopped ||
          simulationState == SimulationStatus.completed) {
        y = simulator.getPlotData(activeSpecies!, activeAttribute!);
      }
    });
  }

  void selectAttribute(String? value) {
    setState(() {
      activeAttribute = value;

      if (simulationState == SimulationStatus.stopped ||
          simulationState == SimulationStatus.completed) {
        y = simulator.getPlotData(activeSpecies!, activeAttribute!);
      }
    });
  }

  @override
  void dispose() {
    simulator.cleanup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

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
                text: "$currentYear / ${widget.years}",
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
              if (simulationState == SimulationStatus.init) {
                return;
              } else if (simulationState == SimulationStatus.ready) {
                startSimulation();
              } else if (simulationState == SimulationStatus.running) {
                stopSimulation();
              } else if (simulationState == SimulationStatus.stopped ||
                  simulationState == SimulationStatus.completed) {
                viewSimulation();
              }
            },
            child: Text(
                simulationState == SimulationStatus.ready ?
                simulateStartBtn :
                simulationState == SimulationStatus.running ?
                simulateStopBtn :
                simulationState == SimulationStatus.stopped ||
                    simulationState == SimulationStatus.completed ?
                simulateViewBtn : ""
            ),
          ),
        ),

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
                      selectSpecies,
                      allSpecies,
                      "Species",
                      activeSpecies,
                    ),
                  ),
                ),


                // Attribute input
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(left: defaultPadding / 2),
                    child: getDropDown(
                      selectAttribute,
                      allAttributes,
                      "Attribute",
                      activeAttribute,
                    ),
                  ),
                )
              ]),
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
                    swapAnimationDuration: const Duration(milliseconds: 15), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ),
                )
            )
        )
      ],
    );
  }
}
