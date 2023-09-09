import 'dart:io';
import 'dart:typed_data';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/schema/report_meta_visualisation_generated.dart' as meta;
import 'package:ecosystem/screens/common/dialog.dart';
import 'package:ecosystem/screens/common/header.dart';
import 'package:ecosystem/screens/common/history_items.dart';
import 'package:ecosystem/screens/common/transition.dart';
import 'package:ecosystem/screens/report/report_screen.dart';
import 'package:ecosystem/utility/report_helpers.dart';
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';

class HistoryBody extends StatefulWidget {
  const HistoryBody({super.key});

  @override
  State<HistoryBody> createState() => _HistoryBodyState();
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
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          // * Header background
          getScreenHeaderBackground(size),

          Container(
            padding: const EdgeInsets.only(
              top: defaultPadding,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  // Title
                  Container(
                      padding: const EdgeInsets.only(
                        left: defaultPadding,
                        right: defaultPadding,
                      ),
                      child: getScreenHeaderText("History"),
                  ),

                  //* Report list
                  Expanded(
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.only(
                          top: defaultPadding * 1.25,
                          left: defaultPadding * 0.75,
                          right: defaultPadding * 0.25,
                        ),
                        decoration: const BoxDecoration(
                          color: colorBackground,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(36),
                              topRight: Radius.circular(36)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [

                            // Loading screen
                            Visibility(
                              visible: loading,
                              child: Lottie.asset(assetLoading),
                            ),

                            // Empty screen
                            Visibility(
                              visible: !loading && reportList.isEmpty,
                              child: Lottie.asset(assetEmpty),
                            ),

                            // Report List
                            Visibility(
                              visible: !loading && reportList.isNotEmpty,
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    end: Alignment.topCenter,
                                    begin: Alignment.bottomCenter,
                                    colors: [Colors.white, Colors.white.withOpacity(0.05)],
                                    stops: const [0.95, 1],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds);
                                },
                                child: SizedBox(
                                  height: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: reportList.length,
                                    itemBuilder: (context, index) {
                                      final item = reportList[index];
                                      return historyReportItem(item, viewReport, deleteReport);
                                    },
                                    physics: const BouncingScrollPhysics(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}
