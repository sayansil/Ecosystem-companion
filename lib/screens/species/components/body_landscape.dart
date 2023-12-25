import 'dart:io';
import 'dart:math';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/sample_species.dart';
import 'package:ecosystem/screens/common/dialog.dart';
import 'package:ecosystem/screens/common/header.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../common/species_item.dart';

class SpeciesLandscapeBody extends StatefulWidget {
  const SpeciesLandscapeBody({super.key});

  @override
  State<SpeciesLandscapeBody> createState() => _SpeciesLandscapeBodyState();
}

class _SpeciesLandscapeBodyState extends State<SpeciesLandscapeBody> {
  String kingdomName = "";

  final textKindController = TextEditingController();
  final textBaseJsonPathController = TextEditingController();
  final textModifyJsonPathController = TextEditingController();

  bool validSpecies = false;

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

  Future<void> saveSpecies(String species, String kingdom, String baseText, String modifyText) async {
    final ecosystemRoot = await getEcosystemRoot();
    final speciesRoot = join(ecosystemRoot, templateDir, kingdom, species);

    final baseFile = File(join(speciesRoot, "base.json"));
    final modifyFile = File(join(speciesRoot, "modify.json"));
    baseFile.createSync(recursive: true);
    modifyFile.createSync(recursive: true);

    baseFile.writeAsStringSync(baseText);
    modifyFile.writeAsStringSync(modifyText);
  }

  void createSpecies(BuildContext context) async {
    final speciesName = textKindController.text.toLowerCase();

    var baseJsonFilePath = textBaseJsonPathController.text;
    var modifyJsonFilePath = textModifyJsonPathController.text;

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

    await saveSpecies(speciesName, kingdomName, baseText, modifyText);

    setState(() {
      textKindController.clear();
      textBaseJsonPathController.clear();
      textModifyJsonPathController.clear();
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(snackBarAddedSpeciesText),
      ));
    }
  }


  void configChanged() {
    final kindName = textKindController.text;

    setState(() {
      if (kingdomName.isNotEmpty && kindName.isNotEmpty) {
        validSpecies = true;
      }
      else {
        validSpecies = false;
      }
    });
  }

  Future<void> confirmFetchSpeciesData(SampleSpecies s, BuildContext context) async {
    bool confirmation = await showYesNoDialog(
        context,
        "Download \"${s.name}\" data? 💾",
        downloadSpeciesMessage,
        downloadSpeciesAccept,
        downloadSpeciesReject,
    );

    if (!confirmation) {
      return;
    }

    var baseResponse = await http.get(Uri.parse(s.baseUrl));
    var modifyResponse = await http.get(Uri.parse(s.modifyUrl));

    if (baseResponse.statusCode != 200 ||
          modifyResponse.statusCode != 200 ||
          baseResponse.body.isEmpty ||
          modifyResponse.body.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(snackBarCannotDownloadText),
        ));
      }
      return;
    }

    await saveSpecies(s.name, s.kingdom.value, baseResponse.body, modifyResponse.body);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(snackBarAddedSpeciesText),
      ));
    }
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

          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white.withOpacity(0.05)],
                stops: const [0.95, 1],
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
              ),
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Title
                  getScreenHeaderText(screenTitleSpecies),

                  Container(
                    constraints: BoxConstraints(
                        maxWidth:max(600, size.width * 0.3)
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                      vertical: defaultPadding / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: defaultCardShadow,
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
                                configChanged();
                              }
                            },
                            items: KingdomName.values.map((KingdomName item) {
                              return DropdownMenuItem<KingdomName>(
                                value: item,
                                child: Text(item.name),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
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
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                            decoration: const InputDecoration(
                              labelText: configKindInputText,
                              labelStyle: editTextStyle,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            controller: textKindController,
                            onChanged: (text) {configChanged();},
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
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  decoration: const InputDecoration(
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
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  decoration: const InputDecoration(
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

                  Container(
                    margin: const EdgeInsets.only(top: defaultPadding * 2),
                    child: const Text(
                      addSampleSpeciesHeader,
                      style: secondaryHeaderStyle,
                    ),
                  ),

                  Flexible(
                      child: SizedBox(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 20, bottom: size.height * 0.3),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 2 / 1,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                            itemCount: sampleSpeciesList.isNotEmpty ? sampleSpeciesList.length : 0,
                            itemBuilder: (BuildContext context, index) {
                              return InkWell(
                                child: sampleSpeciesItem(
                                  sampleSpeciesList[index].kingdom,
                                  sampleSpeciesList[index].name,
                                ),
                                onTap: () {
                                  confirmFetchSpeciesData(sampleSpeciesList[index], context);
                                },
                              );
                            },
                          )
                      ),
                  ),
                ],
              ),
            ),
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
                padding: const EdgeInsets.symmetric(vertical: defaultPadding / 1.5),
              ),
              onPressed: validSpecies ? () {
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
