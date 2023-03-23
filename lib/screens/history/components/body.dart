import 'dart:io';
import 'dart:typed_data';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/schema/generated/report_meta_visualisation_generated.dart' as meta;
import 'package:ecosystem/screens/common/dialog.dart';
import 'package:ecosystem/screens/common/transition.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'header.dart';
import 'package:flutter/material.dart';

class HistoryBody extends StatefulWidget {
  @override
  _HistoryBodyState createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {

  bool loading = true;
  List<meta.Meta> reportList = [];

  Future<void> loadSimulationList() async {

    final ecosystemRoot = await getEcosystemRoot();

    File metaFile = File(join(ecosystemRoot, reportDir, metaDataFileName));

    if (metaFile.existsSync()) {
      Uint8List rawMetaData = metaFile.readAsBytesSync();

      final metaData = meta.MetaData(rawMetaData);

      setState(() {
        reportList = metaData.data!;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      loading = true;
    });

    loadSimulationList().then((value) {
      setState(() {
        loading = false;
      });
    });
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

          // * Form 1
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            height: size.height,
            margin: EdgeInsets.only(
              top: size.height * 0.15 - 60,
            ),
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            decoration: const BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36)),
            ),
          ),
        ],
      ),
    );
  }
}
