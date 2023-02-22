import 'dart:convert';

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
  bool correctKingdom = false;
  bool correctSpecies = false;
  bool correctCount = false;
  bool correctYears = false;

  final textKingdomController = TextEditingController();
  final textSpeciesController = TextEditingController();
  final textCountController = TextEditingController();
  final textYearsController = TextEditingController();

  List<SimulationSet> allSets = [];
  int years = 0;
  
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadAllValues();
  }

  @override
  void dispose() {
    textKingdomController.dispose();
    textSpeciesController.dispose();
    textCountController.dispose();
    textYearsController.dispose();
    super.dispose();
  }

  Future<void> loadAllValues() async {
    prefs = await SharedPreferences.getInstance();

    final _years = prefs.getInt('simulationYears') ?? 0;
    final _sets = prefs.getString('simulationSet') ?? "[]";

    print(_years);

    setState(() {
      allSets = SimulationSet.fromString(_sets);
      if (_years > 0) {
        years = _years;

        setTextValue(textYearsController, years.toString());
      }
    });

    valueChanged('years');
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

  void valueChanged(String valueType) {
    setState(() {
      if (valueType == "kingdom" || valueType == "species") {
        String kingdom = textKingdomController.text.toLowerCase();
        String species = textSpeciesController.text.toLowerCase();

        correctKingdom = false;
        correctSpecies = false;

        var speciesList = completeSpeciesList;
        if (speciesList.containsKey(kingdom)) {
          correctKingdom = true;

          if (speciesList[kingdom]!.contains(species)) {
            correctSpecies = true;
          }
        }
      } else if (valueType == "count") {
        int count = int.tryParse(textCountController.text) ?? 0;

        correctCount = false;

        if (count > 0) {
          correctCount = true;
        }
      } else if (valueType == "years") {
        years = int.tryParse(textYearsController.text) ?? 0;
        correctYears = false;

        if (years > 0) {
          correctYears = true;
        }
      }
    });
  }

  void addSet() {
    if (isValidSet()) {
      setState(() {
        allSets.add(SimulationSet(
            textKingdomController.text.toLowerCase(),
            textSpeciesController.text.toLowerCase(),
            int.tryParse(textCountController.text) ?? 0));

        textKingdomController.clear();
        textSpeciesController.clear();
        textCountController.clear();
      });
      valueChanged('kingdom');
      valueChanged('species');
      valueChanged('count');

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
    return allSets.isNotEmpty && correctYears;
  }

  bool isValidSet() {
    return correctSpecies && correctKingdom && correctCount;
  }

  void simulate() async {
    saveAllValues();

    final textLocalDbPath = prefs.getString('textLocalDbPath') ?? "";
    final textReportLocation = prefs.getString('textReportLocation') ?? "";
    
    if (textLocalDbPath.isEmpty || textReportLocation.isEmpty) {
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
                onChanged: (text) {
                  valueChanged("years");
                },
                controller: textYearsController,
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                              decoration: InputDecoration(
                                labelText: "Kingdom",
                                labelStyle: editTextStyle,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onChanged: (text) {
                                valueChanged("kingdom");
                              },
                              controller: textKingdomController,
                            ),
                          ),
                          Visibility(
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                              size: 30.0,
                            ),
                            visible: correctKingdom,
                          ),
                        ]),
                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                              decoration: InputDecoration(
                                labelText: "Species",
                                labelStyle: editTextStyle,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onChanged: (text) {
                                valueChanged("species");
                              },
                              controller: textSpeciesController,
                            ),
                          ),
                          Visibility(
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                              size: 30.0,
                            ),
                            visible: correctSpecies,
                          ),
                        ]),
                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),
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
                              onChanged: (text) {
                                valueChanged("count");
                              },
                              controller: textCountController,
                            ),
                          ),
                          Visibility(
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                              size: 30.0,
                            ),
                            visible: correctCount,
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
