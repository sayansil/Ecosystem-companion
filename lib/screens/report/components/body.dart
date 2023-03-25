import 'dart:io';
import 'dart:typed_data';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/database/database_manager.dart';
import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:ecosystem/schema/plot_visualisation_generated.dart';
import 'package:ecosystem/schema/world_ecosystem_generated.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/reportHelpers.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';

class ReportBody extends StatefulWidget {
  final String? plotDataPath;

  const ReportBody(this.plotDataPath, {Key? key}): super(key: key);

  @override
  _ReportBodyState createState() => _ReportBodyState();
}

class _ReportBodyState extends State<ReportBody> {
  bool loading = true;
  Uint8List? plotBundleData;
  PlotBundle? plotBundle;

  String? activeSpecies;
  String? activeKingdom;
  List<Plot> activePlots = [];

  Future<void> loadData() async {
    final ecosystemRoot = await getEcosystemRoot();

    if (widget.plotDataPath != null) {
      // Load from file in widget.plotDataPath
      File plotFile = File(join(ecosystemRoot, reportDir, widget.plotDataPath));

      if (plotFile.existsSync()) {
        plotBundleData = plotFile.readAsBytesSync();

        setState(() {
          plotBundle = PlotBundle(plotBundleData!);

          activeSpecies = plotBundle!.plotGroups![0].name;
          activeKingdom = plotBundle!.plotGroups![0].type;
          activePlots = plotBundle!.plotGroups![0].plots!;
        });
      } else {
        ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
          content: Text(invalidReportPath),
        ));
      }
    } else {
      // Load from database
      List<WorldInstance> rows = await MasterDatabase.instance.readAllRows();
      plotBundleData = getPlotData(rows);

      setState(() {
        plotBundle = PlotBundle(plotBundleData!);

        activeSpecies = plotBundle!.plotGroups![0].name;
        activeKingdom = plotBundle!.plotGroups![0].type;
        activePlots = plotBundle!.plotGroups![0].plots!;
      });
    }
  }

  Future<void> saveData() async {
    final currentTs = DateTime.now();
    final ecosystemRoot = await getEcosystemRoot();

    // Save plotBundle to file
    final fileName = "${DateFormat("report-dd.MM.yyyy-hh.mm.ss").format(currentTs)}.ftx";
    File binFile = File(join(ecosystemRoot, reportDir, fileName));
    binFile.createSync(recursive: true);
    binFile.writeAsBytes(plotBundleData!);

    // Update metadata

    Uint8List newMetaData;

    final metaPath = join(ecosystemRoot, reportDir, metaDataFileName);
    File metaFile = File(metaPath);

    if (metaFile.existsSync()) {
      // Attach old meta to new
      newMetaData = addMetaData(
          metaFile.readAsBytesSync(),
          fileName,
          currentTs.millisecondsSinceEpoch,
          plotBundle!
      );
    } else {
      // Create new meta
      metaFile.createSync(recursive: true);
      newMetaData = addMetaData(
          null,
          fileName,
          currentTs.millisecondsSinceEpoch,
          plotBundle!
      );
    }

    metaFile.writeAsBytesSync(newMetaData);
  }

  void setActiveSpecies(String? species) {
    for (final plotGroup in plotBundle!.plotGroups!) {
      if (plotGroup.name == species) {
        setState(() {
          activeSpecies = plotGroup.name;
          activeKingdom = plotGroup.type;
          activePlots = plotGroup.plots!;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      loading = true;
    });

    loadData().then((value) => {
      setState(() {
        loading = false;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: loading,
            child: Lottie.asset(assetLoading)
        ),

        Visibility(
          visible: !loading,
          child: Stack(
            children: [

              // Title
              const Positioned(
                left: defaultPadding,
                child: Text(
                  "Simulation\nReport",
                  style: hugeHeaderStyle,
                )
              ),

              // Actions Bar
              Positioned(
                  right: defaultPadding,
                  top: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [

                          // Export button
                          ElevatedButton(
                            onPressed: null,
                            style: menuButtonStyle,
                            child: const Text("Export"),
                          ),


                          const SizedBox(
                            width: 15,
                          ),

                          // Save button
                          ElevatedButton(
                            onPressed: () {
                              saveData().then((value) => ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
                                content: Text(snackBarSavedReportText),
                              )));
                            },
                            style: menuButtonStyle,
                            child: const Text("Save"),
                          ),
                        ],
                      ),

                      // Species dropdown
                      Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: DropdownButtonFormField<String>(
                              icon: const Icon(Icons.arrow_downward_rounded),
                              elevation: 10,
                              style: dropdownOptionStyle,
                              onChanged: (String? item) =>
                                  setActiveSpecies(item),
                              value: activeSpecies,
                              items: plotBundle?.plotGroups!.map((item) => DropdownMenuItem<String>(
                                value: item.name!,
                                child: Text(item.name!),
                              )).toList(),
                              decoration: const InputDecoration(
                                labelText: "Species",
                                labelStyle: editTextStyle,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              )
                            ),
                          )
                        ],
                      )
                    ],
                  )
              ),
            ]
          )
        )
      ],
    );
  }
}