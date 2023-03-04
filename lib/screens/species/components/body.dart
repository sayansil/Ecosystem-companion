import 'dart:io';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:path/path.dart';

import 'header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class SpeciesBody extends StatefulWidget {
  @override
  _SpeciesBodyState createState() => _SpeciesBodyState();
}

class _SpeciesBodyState extends State<SpeciesBody> {
  String kingdomName = "";

  final textKindController = TextEditingController();

  @override
  void dispose() {
    textKindController.dispose();
    super.dispose();
  }

  void createSpecies(BuildContext context) async {
    final speciesName = textKindController.text.toLowerCase();

    final ecosystemRoot = await getEcosystemRoot();
    final speciesRoot = join(ecosystemRoot, templateDir, kingdomName, speciesName);

    final baseFile = await File(join(speciesRoot, "base.json")).create(recursive: true);
    final modifyFile = await File(join(speciesRoot, "modify.json")).create(recursive: true);

    final baseText = await rootBundle.loadString(join(assetSpeciesTemplatePath, kingdomName, "base.json"));
    final modifyText = await rootBundle.loadString(join(assetSpeciesTemplatePath, kingdomName, "modify.json"));

    baseFile.writeAsStringSync(baseText);
    modifyFile.writeAsStringSync(modifyText);

    setState(() {
      textKindController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(snackBarAddedSpeciesText),
    ));
  }

  bool isValid() {
    final kindName = textKindController.text;
    return kingdomName.isNotEmpty && kindName.isNotEmpty;
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

          // * Form 1
          Container(
            constraints: BoxConstraints(maxWidth: 600),
            height: 200,
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
                  DropdownButtonFormField<KingdomName>(
                    icon: const Icon(Icons.arrow_downward_rounded),
                    elevation: 15,
                    style: dropdownOptionStyle,
                    onChanged: (KingdomName? item) {
                      if (item != null) {
                        kingdomName = item.name;
                      }
                    },
                    items: KingdomName.values.map((KingdomName item) {
                      return DropdownMenuItem<KingdomName>(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: configKingdomInputText,
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
                  TextField(
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                      labelText: configKindInputText,
                      labelStyle: editTextStyle,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    controller: textKindController,
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
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.symmetric(vertical: defaultPadding / 1.5),
              ),
              onPressed: isValid() ? () {
                createSpecies(context);
              } : null,
              child: const Text(addSpeciesBtn),
            ),
          ),
        ],
      ),
    );
  }
}
