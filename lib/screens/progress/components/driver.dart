import 'package:ecosystem/screens/common/dropdown.dart';
import 'package:ecosystem/screens/common/transition.dart';
import 'package:ecosystem/screens/progress/components/landscape.dart';
import 'package:ecosystem/screens/progress/components/portrait.dart';
import 'package:ecosystem/screens/report/report_screen.dart';
import 'package:native_simulator/native_simulator.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:recase/recase.dart';

class ProgressBody extends StatefulWidget {
  final int years;
  final List<SimulationSet> initOrganisms;

  const ProgressBody(this.years, this.initOrganisms, {Key? key}): super(key: key);

  @override
  State<ProgressBody> createState() => ProgressBodyState();
}

class ProgressBodyState extends State<ProgressBody> {
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
    simulator.closeSimulation();
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
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait ?
            getPortraitBody(this) :
            getLandscapeBody(this);
        }
    );
  }
}
