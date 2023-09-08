import 'dart:io';
import 'dart:math';

import 'package:ecosystem/screens/common/header.dart';
import 'package:path/path.dart' as path;
import 'package:ecosystem/screens/progress/progress_screen.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:flutter/services.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/simulation_item.dart';
import '../../common/transition.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
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

    if (dirNames.isEmpty) {
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
    Size size = MediaQuery.of(context).size;

    return Container(
        constraints: const BoxConstraints.expand(),
        child: Stack(
          children: <Widget>[
            // * Header background
            getScreenHeaderBackground(size),

            Container(
              padding: const EdgeInsets.only(
                top: defaultPadding,
                left: defaultPadding,
                right: defaultPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  // Title
                  getScreenHeaderText("Ecosystem Simulator"),

                  Stack(
                    children: [
                      // Light grey background
                      Container(
                        constraints: BoxConstraints(maxWidth:
                          max(600, size.width * 0.3)
                        ),
                        margin: const EdgeInsets.only(top: 20),
                        height: 300,
                        decoration: BoxDecoration(
                          color: colorPrimaryLight,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 10),
                              blurRadius: 50,
                              color: colorPrimary.withOpacity(0.23),
                            ),
                          ],
                        )
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // * Form 1
                          Container(
                            constraints: BoxConstraints(maxWidth:
                              max(600, size.width * 0.3)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                            decoration: BoxDecoration(
                              color: colorPrimaryLight,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 10),
                                  blurRadius: 50,
                                  color: colorPrimary.withOpacity(0.23),
                                ),
                              ],
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
                              controller: textYearsController,
                              onChanged: (String? text) {
                                years = int.tryParse(textYearsController.text) ?? 0;
                                simulationConfigChanged();
                              },
                            ),
                          ),

                          // * Form 2
                          Container(
                            constraints: BoxConstraints(maxWidth:
                              max(600, size.width * 0.3)
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding,
                                vertical: defaultPadding / 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 10),
                                  blurRadius: 50,
                                  color: colorPrimary.withOpacity(0.23),
                                ),
                              ],
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
                                        kingdomName = item;
                                        configChanged();
                                        fetchSpeciesList(kingdomName);
                                      }
                                    },
                                    items: kingdomList.map((e) => DropdownMenuItem<String>(
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
                                        speciesName = item;
                                        configChanged();
                                      }
                                    },
                                    items: speciesList.map((e) => DropdownMenuItem<String>(
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
                                                textAgeController.text.isNotEmpty &&
                                                    !isValidNumber(textAgeController) ?
                                                "Invalid value" : null
                                            ),
                                            controller: textAgeController,
                                            onChanged: (text) {configChanged();},
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
                                                textCountController.text.isNotEmpty &&
                                                    !isValidNumber(textCountController) ?
                                                "Invalid value" : null
                                            ),
                                            controller: textCountController,
                                            onChanged: (text) {configChanged();},
                                          ),
                                        )
                                      ]),

                                  // Add set button
                                  ElevatedButton(
                                    onPressed: isSetReady
                                        ? () {
                                      addSet();
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

                  Flexible(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.white.withOpacity(0.05)],
                            stops: const [0.95, 1],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        child: SizedBox(
                          height: double.infinity,
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: 40, bottom: size.height * 0.1),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                            itemCount: allSets.isNotEmpty ? allSets.length + 1 : 0,
                            itemBuilder: (BuildContext context, index) {
                              return index < allSets.length ? speciesSetItem(
                                  allSets[index].kingdom,
                                  allSets[index].species,
                                  allSets[index].age,
                                  allSets[index].count
                              ) : Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: colorSecondary,
                                  iconSize: 35,
                                  onPressed: () {
                                    clearSets();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      )
                  )
                  // * Card List of selected Species
                ],
              ),
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
                onPressed: isSimulationReady ? () {
                  simulate();
                } : null,
                child: const Text(simulateBtn),
              ),
            ),
          ],
        ));
  }
}
