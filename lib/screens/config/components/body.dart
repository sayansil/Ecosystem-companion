import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'header.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigBody extends StatefulWidget {
  @override
  _ConfigBodyState createState() => _ConfigBodyState();
}

class _ConfigBodyState extends State<ConfigBody> {
  final textLocalDbPathController = TextEditingController();
  final textReportLocationController = TextEditingController();

  String textLocalDbPath = "";
  String textReportLocation = "";

  late SharedPreferences prefs;

  @override
  void dispose() {
    textLocalDbPathController.dispose();
    textReportLocationController.dispose();
    super.dispose();
  }

  VoidCallback? saveValues() {
    textLocalDbPath = textLocalDbPathController.text;
    textReportLocation = textReportLocationController.text;

    prefs.setString('textLocalDbPath', textLocalDbPath);
    prefs.setString('textReportLocation', textReportLocation);

    ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(
        'Saved successfully!',
        style: snackBarTextStyle,
      )));
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

    textLocalDbPath = prefs.getString('textLocalDbPath') ?? "";
    textReportLocation = prefs.getString('textReportLocation') ?? "";

    setTextValue(textLocalDbPathController, textLocalDbPath);
    setTextValue(textReportLocationController, textReportLocation);
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
                        labelText: configLocalDbPathText,
                        labelStyle: editTextStyle,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      controller: textLocalDbPathController,
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
                        labelText: configLocalReportDirText,
                        labelStyle: editTextStyle,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      controller: textReportLocationController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      saveValues();
                    },
                    child: Text(saveConfigBtn),
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
        ],
      ),
    );
  }
}
