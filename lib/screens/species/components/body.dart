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
  void createSpecies(String kingdomName, String speciesName) async {
    final ecosystemRoot = await getEcosystemRoot();
    final speciesRoot = join(ecosystemRoot, templateDir, kingdomName, speciesName);

    final baseFile = await File(join(speciesRoot, "base.json")).create(recursive: true);
    final modifyFile = await File(join(speciesRoot, "modify.json")).create(recursive: true);

    final baseText = await rootBundle.loadString(join(assetSpeciesTemplatePath, kingdomName, "base.json"));
    final modifyText = await rootBundle.loadString(join(assetSpeciesTemplatePath, kingdomName, "modify.json"));

    baseFile.writeAsStringSync(baseText);
    modifyFile.writeAsStringSync(modifyText);
    print("Created species successfully.");
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
              onPressed: () {},
              child: const Text(addSpeciesBtn),
            ),
          ),
        ],
      ),
    );
  }
}
