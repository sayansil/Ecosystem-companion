import 'dart:io';
import 'dart:typed_data';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/schema/report_meta_visualisation_generated.dart' as meta;
import 'package:ecosystem/screens/history/components/body/portrait.dart';
import 'package:ecosystem/screens/history/components/body/landscape.dart';
import 'package:ecosystem/screens/common/dialog.dart';
import 'package:ecosystem/screens/common/transition.dart';
import 'package:ecosystem/screens/report/report_screen.dart';
import 'package:ecosystem/utility/report_helpers.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';

class HistoryBody extends StatefulWidget {
  const HistoryBody({super.key});

  @override
  State<HistoryBody> createState() => HistoryBodyState();
}

class HistoryBodyState extends State<HistoryBody> {

  bool loading = true;
  List<meta.Meta> reportList = [];

  Future<void> loadSimulationList() async {

    final ecosystemRoot = await getEcosystemRoot();

    File metaFile = File(join(ecosystemRoot, reportDir, metaDataFileName));

    if (metaFile.existsSync()) {
      Uint8List rawMetaData = metaFile.readAsBytesSync();

      final metaData = meta.MetaData(rawMetaData);
      List<meta.Meta> sortedMetaList = metaData.data!
          .toList(growable: false)
        ..sort((a, b) => b.createdTs.compareTo(a.createdTs));

      setState(() {
        reportList = sortedMetaList;
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

  void viewReport(String fileName) {
    Navigator.push(
        this.context,
        buildPageRoute(ReportScreen(fileName))
    ).then((value) => loadSimulationList());
  }

  Future<void> deleteReportAsync(String fileName) async {
    final ecosystemRoot = await getEcosystemRoot();
    File binFile = File(join(ecosystemRoot, reportDir, fileName));
    if (binFile.existsSync()) {
      binFile.deleteSync();
    }

    File metaFile = File(join(ecosystemRoot, reportDir, metaDataFileName));
    final rawMetaData = metaFile.readAsBytesSync();
    final newMetaData = removeMetaData(rawMetaData, fileName);
    metaFile.writeAsBytesSync(newMetaData);
  }

  void deleteReport(String fileName) {
    showYesNoDialog(
        this.context,
        confirmDeleteTitle,
        confirmDeleteMessage,
        confirmDeleteAccept,
        confirmDeleteReject,
        defaultYes: true
    ).then((response) {
      if (response) {
        setState(() {
          loading = true;
        });

        deleteReportAsync(fileName)
            .then((value) =>
            loadSimulationList().then((value) {
              setState(() {
                loading = false;
              });
            }));
      }
    });
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
