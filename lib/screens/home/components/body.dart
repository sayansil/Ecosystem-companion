import 'dart:io';

import 'package:path/path.dart' as Path;
import 'package:ecosystem/screens/common/dialog.dart';
import 'package:ecosystem/screens/results/results_screen.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:flutter/services.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/transition.dart';
import '../../config/config_screen.dart';
import 'header.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<String> kingdomList = [];
  List<String> speciesList = [];

  final textCountController = TextEditingController();
  final textYearsController = TextEditingController();

  List<SimulationSet> allSets = [];

  int years = 0;
  String kingdomName = "";
  String speciesName = "";

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadAllValues();
  }

  @override
  void dispose() {
    textCountController.dispose();
    textYearsController.dispose();
    super.dispose();
  }

  Future<void> fetchKingdomList() async {
    final ecosystemRoot = await getEcosystemRoot();
    final ecosystemDataDir = Directory(Path.join(ecosystemRoot, templateDir));

    final children = await ecosystemDataDir.list().toList();
    final Iterable<Directory> dirs = children.whereType<Directory>();
    final List<String> dirNames = dirs.map((e) => Path.basename(e.path)).toList();

    setState(() {
      kingdomList = dirNames;
    });
  }

  Future<void> fetchSpeciesList(String kingdom) async {
    final ecosystemRoot = await getEcosystemRoot();
    final ecosystemKingdomDir = Directory(Path.join(ecosystemRoot, templateDir, kingdom));

    final children = await ecosystemKingdomDir.list().toList();
    final Iterable<Directory> dirs = children.whereType<Directory>();
    final List<String> dirNames = dirs.map((e) => Path.basename(e.path)).toList();

    if (dirNames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(noSpeciesFound),
      ));
    }

    setState(() {
      speciesList = dirNames;
    });
  }

  Future<void> loadAllValues() async {
    prefs = await SharedPreferences.getInstance();

    final _years = prefs.getInt('simulationYears') ?? 0;
    final _sets = prefs.getString('simulationSet') ?? "[]";

    setState(() {
      allSets = SimulationSet.fromString(_sets);
      if (_years > 0) {
        years = _years;
        setTextValue(textYearsController, years.toString());
      }
    });

    fetchKingdomList();
  }

  Future<void> saveAllValues() async {
    final _sets = SimulationSet.asString(allSets);

    prefs.setInt('simulationYears', years);
    prefs.setString('simulationSet', _sets);
  }

  void setTextValue(TextEditingController controller, String text) {
    controller.value = controller.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(
        offset: controller.value.selection.baseOffset + text.length,
      ),
    );
  }

  bool isValidSet() {
    int count = int.tryParse(textCountController.text) ?? 0;
    return count > 0 && kingdomName.isNotEmpty && speciesName.isNotEmpty;
  }

  void addSet() {
    if (isValidSet()) {
      setState(() {
        allSets.add(SimulationSet(
            kingdomName,
            speciesName,
            int.tryParse(textCountController.text) ?? 0));

        textCountController.clear();
      });

      saveAllValues();
    }
  }

  void clearSets() {
    setState(() {
      allSets = [];
    });

    final _sets = SimulationSet.asString([]);
    prefs.setString('simulationSet', _sets);
  }

  bool isReady() {
    return allSets.isNotEmpty && years > 0;
  }

  void simulate() async {
    saveAllValues();

    final textReportLocation = prefs.getString('textReportLocation') ?? "";

    if (textReportLocation.isEmpty) {
      // Configs not yet set
      if (await showYesNoDialog(
          context,
          addConfigsTitle,
          addConfigsMessage,
          addConfigsAccept,
          addConfigsReject)) {
        Navigator.push(context, buildPageRoute(ConfigScreen()));
      }
    } else {
      // Config values set properly
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ResultScreen(this.years, this.allSets)
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: <Widget>[
            // * Header bar
            BodyHeader(parentSize: size),

            // * Card List of selected Species
            Container(
              margin: EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: size.height * 0.3 + 160,
              ),
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 40, bottom: size.height * 0.1),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: allSets.isNotEmpty ? allSets.length + 1 : 0,
                itemBuilder: (BuildContext context, index) {
                  return index < allSets.length
                      ? Container(
                          child: Stack(children: <Widget>[
                            Positioned(
                              top: 10,
                              left: 15,
                              right: 15,
                              child: Container(
                                child: Text(
                                  allSets[index].species,
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              left: 15,
                              right: 15,
                              child: Container(
                                child: Text(
                                  allSets[index].kingdom,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 15,
                              child: Container(
                                child: Text(
                                  allSets[index].count.toString(),
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                          ]),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: colorSecondary,
                            iconSize: 35,
                            onPressed: () {
                              clearSets();
                            },
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        );
                },
              ),
            ),

            // * Form 1
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              height: 100,
              margin: EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: size.height * 0.15 - 60,
              ),
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              decoration: BoxDecoration(
                color: colorPrimaryLight,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
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
                decoration: InputDecoration(
                  labelText: "Years to Simulate",
                  labelStyle: editTextDarkStyle,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                controller: textYearsController,
                onChanged: (String? text) {
                  years = int.tryParse(textYearsController.text) ?? 0;
                },
              ),
            ),

            // * Form 2
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              height: 300,
              margin: EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: size.height * 0.15,
              ),
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
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
                          fetchSpeciesList(kingdomName);
                        }
                      },
                      items: kingdomList.map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      )).toList(),
                      decoration: InputDecoration(
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
                        }
                      },
                      items: speciesList.map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      )).toList(),
                      decoration: InputDecoration(
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

                    // Count input
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              style: TextStyle(
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
                              ),
                              controller: textCountController,
                            ),
                          ),
                          Visibility(
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                              size: 30.0,
                            ),
                            visible: (int.tryParse(textCountController.text) ?? 0) > 0,
                          ),
                        ]),
                    ElevatedButton(
                      onPressed: isValidSet()
                          ? () {
                              addSet();
                            }
                          : null,
                      child: Text(addSpeciesBtn),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        foregroundColor: Colors.white,
                        textStyle: buttonStyle,
                        minimumSize: Size(double.infinity, 30),
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(
                            vertical: defaultPadding / 1.5),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ]),
            ),

            // * Bottom Submit Button
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  textStyle: bigButtonStyle,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // <-- Radius
                  ),
                  padding: EdgeInsets.symmetric(vertical: defaultPadding / 1.5),
                ),
                onPressed: isReady() ? () {
                  simulate();
                } : null,
                child: const Text(simulateBtn),
              ),
            ),
          ],
        ));
  }
}
