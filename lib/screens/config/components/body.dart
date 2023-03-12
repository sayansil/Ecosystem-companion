import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'header.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigBody extends StatefulWidget {
  @override
  _ConfigBodyState createState() => _ConfigBodyState();
}

class _ConfigBodyState extends State<ConfigBody> {
  final textReportLocationController = TextEditingController();
  final textRootController = TextEditingController();

  String textReportLocation = "";
  String textEcosystemRoot = "";

  bool updatedConfigs = false;

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadAllValues();
  }

  @override
  void dispose() {
    textReportLocationController.dispose();
    textRootController.dispose();
    super.dispose();
  }

  void configChanged() {
    setState(() {
      updatedConfigs = true;
    });
  }

  void saveValues() {
    textReportLocation = textReportLocationController.text;

    prefs.setString('textReportLocation', textReportLocation);

    setState(() {
      updatedConfigs = false;
    });

    ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text(
        'Saved successfully!',
        style: snackBarTextStyle,
      )));
  }

  void setTextValue(TextEditingController controller, String text) {
    controller.value = controller.value.copyWith(
      text: text,
      selection: TextSelection.fromPosition(
        TextPosition(offset: text.length),
      ),
    );
  }

  Future<void> loadAllValues() async {
    prefs = await SharedPreferences.getInstance();
    final ecosystemRoot = await getEcosystemRoot();

    textReportLocation = prefs.getString('textReportLocation') ?? "";
    textEcosystemRoot = ecosystemRoot;

    setTextValue(textReportLocationController, textReportLocation);
    setTextValue(textRootController, textEcosystemRoot);
  }

  void fillPath() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      setTextValue(textReportLocationController, selectedDirectory);
      textReportLocation = selectedDirectory;
      configChanged();
    }
  }

  void copyRootPath() {
    Clipboard.setData(ClipboardData(text: textEcosystemRoot))
        .then((_) => ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(
            'Copied!',
            style: snackBarTextStyle,
          ))));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          // * Header bar
          BodyHeader(parentSize: size),

          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            height: 100,
            margin: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: size.height * 0.15 - 40,
            ),
            padding: const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: defaultPadding / 2
            ),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: TextField(
                    enabled: false,
                    style: TextStyle(
                        fontSize: 18.0, color: Colors.white.withOpacity(0.8)),
                    decoration: const InputDecoration(
                      labelText: "Ecosystem root path",
                      labelStyle: editTextDarkStyle,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    controller: textRootController,
                    onTap: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text(
                        'Cannot be edited!',
                        style: snackBarTextStyle,
                      )));
                    },
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(
                    top: defaultPadding / 3
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.copy_rounded, color: colorSecondary),
                    iconSize: 25,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: copyRootPath,
                  ),
                ),
              ],
            )
          ),

          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            height: 200,
            margin: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: size.height * 0.20,
            ),
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
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

                  // Report directory path input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                          decoration: const InputDecoration(
                            labelText: configLocalReportDirText,
                            labelStyle: editTextStyle,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          controller: textReportLocationController,
                          onChanged: (text) {configChanged();},
                        ),
                      ),

                      IconButton(
                        icon: Image.asset('assets/images/folder.png'),
                        iconSize: 30,
                        onPressed: () {fillPath();},
                      )
                    ],
                  ),

                  // Save button
                  ElevatedButton(
                    onPressed: updatedConfigs ? () {
                      saveValues();
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      foregroundColor: Colors.white,
                      textStyle: buttonStyle,
                      minimumSize: const Size(double.infinity, 30),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding / 1.5),
                    ),
                    child: const Text(saveConfigBtn),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
