import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:ecosystem/screens/progress/progress_screen.dart';
import 'package:ecosystem/screens/home/components/body/landscape.dart';
import 'package:ecosystem/screens/home/components/body/portrait.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/transition.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => HomeBodyState();
}

class HomeBodyState extends State<HomeBody> {
  List<String> kingdomList = [];
  List<String> speciesList = [];

  final textCountController = TextEditingController();
  final textAgeController = TextEditingController();
  final textYearsController = TextEditingController();

  List<SimulationSet> allSets = [];

  int years = 0;
  String kingdomName = "";
  String speciesName = "";

  late SharedPreferences prefs;

  bool isSetReady = false;
  bool isSimulationReady = false;

  @override
  void initState() {
    super.initState();
    loadAllValues();
  }

  @override
  void dispose() {
    textCountController.dispose();
    textYearsController.dispose();
    textAgeController.dispose();
    super.dispose();
  }

  Future<void> fetchKingdomList() async {
    final ecosystemRoot = await getEcosystemRoot();
    final ecosystemDataDir = Directory(path.join(ecosystemRoot, templateDir));

    if (ecosystemDataDir.existsSync()) {
      final children = await ecosystemDataDir.list().toList();
      final Iterable<Directory> dirs = children.whereType<Directory>();
      final List<String> dirNames = dirs.map((e) => path.basename(e.path)).toList();

      setState(() {
        kingdomList = dirNames;
      });
    }
  }

  Future<void> fetchSpeciesList(String kingdom) async {
    final ecosystemRoot = await getEcosystemRoot();
    final ecosystemKingdomDir = Directory(path.join(ecosystemRoot, templateDir, kingdom));

    final children = await ecosystemKingdomDir.list().toList();
    final Iterable<Directory> dirs = children.whereType<Directory>();
    final List<String> dirNames = dirs.map((e) => path.basename(e.path)).toList();

    if (dirNames.isEmpty && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(noSpeciesFound),
      ));
    }

    setState(() {
      speciesList = dirNames;
    });
  }

  Future<void> loadAllValues() async {
    isSetReady = false;
    isSimulationReady = false;
    prefs = await SharedPreferences.getInstance();

    final fetchedYears = prefs.getInt('simulationYears') ?? 0;
    final fetchedSets = prefs.getString('simulationSet');

    if (fetchedYears > 0 && fetchedSets != null) {
      final unpackedSets = SimulationSet.fromString(fetchedSets);

      if (await SimulationSet.isValidSets(unpackedSets)) {
        setState(() {
          years = fetchedYears;
          allSets = unpackedSets;
          setTextValue(textYearsController, years.toString());
        });

        simulationConfigChanged();
      }
    }

    fetchKingdomList();
  }

  Future<void> saveAllValues() async {
    final currentSets = SimulationSet.asString(allSets);

    prefs.setInt('simulationYears', years);
    prefs.setString('simulationSet', currentSets);
  }

  void setTextValue(TextEditingController controller, String text) {
    controller.value = controller.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(
        offset: controller.value.selection.baseOffset + text.length,
      ),
    );
  }

  void addSet() {
    if (isSetReady) {
      int count = int.tryParse(textCountController.text) ?? 0;
      int age = int.tryParse(textAgeController.text) ?? 0;

      setState(() {
        allSets.add(SimulationSet(
            kingdomName,
            speciesName,
            count,
            age
        ));

        textCountController.clear();
        textAgeController.clear();
        isSetReady = false;
      });
      simulationConfigChanged();
      saveAllValues();
    }
  }

  void clearSets() {
    setState(() {
      allSets = [];
    });

    simulationConfigChanged();
    final currentSets = SimulationSet.asString([]);
    prefs.setString('simulationSet', currentSets);
  }

  bool isValidNumber(controller) {
    return (int.tryParse(controller.text) ?? 0) > 0;
  }

  void configChanged() {
    int count = int.tryParse(textCountController.text) ?? 0;
    int age = int.tryParse(textAgeController.text) ?? 0;

    setState(() {
      isSetReady = count > 0 &&
          age > 0 &&
          kingdomName.isNotEmpty &&
          speciesName.isNotEmpty;
    });
  }

  void simulationConfigChanged() {
    setState(() {
      isSimulationReady = allSets.isNotEmpty && years > 0;
    });
  }

  void simulate() {
    saveAllValues();

    Navigator.push(context, buildPageRoute(ProgressScreen(years, allSets)));
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
