import 'package:ecosystem/constants.dart';
import 'header.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigBody extends StatefulWidget {
  @override
  _ConfigBodyState createState() => _ConfigBodyState();
}

class _ConfigBodyState extends State<ConfigBody> {
  final textLocalServerURLController = TextEditingController();
  final textReportLocationController = TextEditingController();
  final textSimulationDirectoryController = TextEditingController();

  String textLocalServerURL = "";
  String textReportLocation = "";
  String textSimulationDirectory = "";

  late SharedPreferences prefs;

  @override
  void dispose() {
    textLocalServerURLController.dispose();
    textReportLocationController.dispose();
    textSimulationDirectoryController.dispose();
    super.dispose();
  }

  VoidCallback? saveValues() {
    textLocalServerURL = textLocalServerURLController.text;
    textReportLocation = textReportLocationController.text;
    textSimulationDirectory = textSimulationDirectoryController.text;

    prefs.setString('textLocalServerURL', textLocalServerURL);
    prefs.setString('textReportLocation', textReportLocation);
    prefs.setString('textSimulationDirectory', textSimulationDirectory);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Saved successfully!')));
  }

  void setTextValue(TextEditingController controller, String text) {
    controller.value = controller.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(
        offset: controller.value.selection.baseOffset + text.length,
      ),
    );
  }

  Future<void> loadAllValues() async {
    prefs = await SharedPreferences.getInstance();

    textLocalServerURL = prefs.getString('textLocalServerURL') ?? "";
    textReportLocation = prefs.getString('textReportLocation') ?? "";
    textSimulationDirectory = prefs.getString('textSimulationDirectory') ?? "";

    setTextValue(textLocalServerURLController, textLocalServerURL);
    setTextValue(textReportLocationController, textReportLocation);
    setTextValue(textSimulationDirectoryController, textSimulationDirectory);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    loadAllValues();

    return Container(
      constraints: BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          // * Header bar
          BodyHeader(parentSize: size),

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
                  Flexible(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        labelText: "Local ecosystem server URL",
                        labelStyle:
                            TextStyle(color: colorPrimary.withOpacity(0.5)),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      controller: textLocalServerURLController,
                    ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  Flexible(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        labelText: "Report saving location",
                        labelStyle:
                            TextStyle(color: colorPrimary.withOpacity(0.5)),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      controller: textReportLocationController,
                    ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  Flexible(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        labelText: "On-device simulation directory",
                        labelStyle:
                            TextStyle(color: colorPrimary.withOpacity(0.5)),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      controller: textSimulationDirectoryController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      saveValues();
                    },
                    child: Text('SAVE'),
                    style: ElevatedButton.styleFrom(
                      primary: colorPrimary,
                      textStyle: const TextStyle(fontSize: 16),
                      minimumSize: Size(double.infinity, 30),
                      onPrimary: Colors.white,
                      shape: StadiumBorder(),
                      padding:
                          EdgeInsets.symmetric(vertical: defaultPadding / 1.5),
                    ),
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
