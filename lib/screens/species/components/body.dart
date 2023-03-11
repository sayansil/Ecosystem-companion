import 'dart:io';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final textBaseJsonPathController = TextEditingController();
  final textModifyJsonPathController = TextEditingController();

  @override
  void dispose() {
    textKindController.dispose();
    textBaseJsonPathController.dispose();
    textModifyJsonPathController.dispose();
    super.dispose();
  }

  void setTextValue(TextEditingController controller, String text) {
    controller.value = controller.value.copyWith(
      text: text,
      selection: TextSelection.fromPosition(
        TextPosition(offset: text.length),
      ),
    );
  }

  void fillPath(TextEditingController controller) async {
    FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'JSON'],
    );

    if (selectedFile?.files.single.path != null) {
      setTextValue(controller, selectedFile!.files.single.path!);
    }
  }

  void createSpecies(BuildContext context) async {
    final speciesName = textKindController.text.toLowerCase();

    final ecosystemRoot = await getEcosystemRoot();
    final speciesRoot = join(ecosystemRoot, templateDir, kingdomName, speciesName);

    var baseJsonFilePath = textBaseJsonPathController.text;
    var modifyJsonFilePath = textModifyJsonPathController.text;

    if (baseJsonFilePath.isNotEmpty || modifyJsonFilePath.isNotEmpty) {
      if (await Permission.storage.isRestricted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(permissionStorageNotGranted),
        ));
        return;
      } else if (!await Permission.storage.request().isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(permissionStorageGrantRequest),
        ));
        return;
      }
    }

    final baseFile = File(join(speciesRoot, "base.json"));
    final modifyFile = File(join(speciesRoot, "modify.json"));
    baseFile.createSync(recursive: true);
    modifyFile.createSync(recursive: true);

    String baseText = "";
    String modifyText = "";

    if (baseJsonFilePath.isNotEmpty) {
      final baseReadFile = File(baseJsonFilePath);
      baseText = baseReadFile.readAsStringSync();
    } else {
      baseText = await rootBundle.loadString(join(assetSpeciesTemplatePath, kingdomName, "base.json"));
    }

    if (modifyJsonFilePath.isNotEmpty) {
      final modifyReadFile = File(modifyJsonFilePath);
      modifyText = modifyReadFile.readAsStringSync();
    } else {
      modifyText = await rootBundle.loadString(join(assetSpeciesTemplatePath, kingdomName, "modify.json"));
    }

    baseFile.writeAsStringSync(baseText);
    modifyFile.writeAsStringSync(modifyText);

    setState(() {
      textKindController.clear();
      textBaseJsonPathController.clear();
      textModifyJsonPathController.clear();
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
            height: 350,
            margin: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: size.height * 0.10,
            ),
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: defaultPadding / 2,
            ),
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
                    elevation: 20,
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


                  const Divider(
                    height: 0,
                    thickness: 1,
                  ),


                  // Base Json file input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          decoration: InputDecoration(
                            labelText: speciesSelectBaseJsonPath,
                            labelStyle: editTextStyle,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          controller: textBaseJsonPathController,
                        ),
                      ),

                      IconButton(
                        icon: Image.asset('assets/images/folder.png'),
                        iconSize: 30,
                        onPressed: () {fillPath(textBaseJsonPathController);},
                      )
                    ],
                  ),


                  const Divider(
                    height: 0,
                    thickness: 1,
                  ),


                  // Modify json file input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          decoration: InputDecoration(
                            labelText: speciesSelectModifyJsonPath,
                            labelStyle: editTextStyle,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          controller: textModifyJsonPathController,
                        ),
                      ),

                      IconButton(
                        icon: Image.asset('assets/images/folder.png'),
                        iconSize: 30,
                        onPressed: () {fillPath(textModifyJsonPathController);},
                      )
                    ],
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
