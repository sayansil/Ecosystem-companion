import 'dart:io';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/sample_species.dart';
import 'package:ecosystem/screens/common/dialog.dart';
import 'package:ecosystem/screens/species/components/body/portrait.dart';
import 'package:ecosystem/screens/species/components/body/landscape.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;


class SpeciesBody extends StatefulWidget {
  const SpeciesBody({super.key});

  @override
  State<SpeciesBody> createState() => SpeciesBodyState();
}

class SpeciesBodyState extends State<SpeciesBody> {
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
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait ?
          getPortraitBody(this) :
          getLandscapeBody(this);
        }
    );
  }
}
