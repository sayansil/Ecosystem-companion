import 'dart:io';
import 'dart:typed_data';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/database/database_manager.dart';
import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:ecosystem/schema/plot_visualisation_generated.dart';
import 'package:ecosystem/screens/common/plot_item.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/reportHelpers.dart' as report;
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  List<report.RenderObject>? renderObjects;

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
      } else {
        ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
          content: Text(invalidReportPath),
        ));
        return;
      }
    } else {
      // Load from database
      List<WorldInstance> rows = await MasterDatabase.instance.readAllRows();
      plotBundleData = report.getPlotData(rows);
    }

    final currentPlotBundle = PlotBundle(plotBundleData!);
    final currentRenderObjects = report.getRenderObjects(
      currentPlotBundle.plotGroups![0].plots!,
      currentPlotBundle.plotGroups![0].type!,
      currentPlotBundle.plotGroups![0].name!,
    );

    setState(() {
      plotBundle = currentPlotBundle;
      renderObjects = currentRenderObjects;

      activeSpecies = plotBundle!.plotGroups![0].name;
      activeKingdom = plotBundle!.plotGroups![0].type;
      activePlots = plotBundle!.plotGroups![0].plots!;
    });
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
      newMetaData = report.addMetaData(
          metaFile.readAsBytesSync(),
          fileName,
          currentTs.millisecondsSinceEpoch,
          plotBundle!
      );
    } else {
      // Create new meta
      metaFile.createSync(recursive: true);
      newMetaData = report.addMetaData(
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
        final currentRenderObjects = report.getRenderObjects(
          plotGroup.plots!,
          plotGroup.type!,
          plotGroup.name!,
        );

        setState(() {
          renderObjects = currentRenderObjects;

          activeSpecies = plotGroup.name;
          activeKingdom = plotGroup.type;
          activePlots = plotGroup.plots!;
        });
      }
    }
  }

  Widget getFooter() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(
        left: defaultPadding / 2,
        right: defaultPadding / 2,
        top: 100,
        bottom: defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(footerTitleText, style: footerTitleTextStyle),
          RichText(text: TextSpan(
            children: [
              const TextSpan(
                text: "by ",
                style: footerSubtitleTextStyle,
              ),
              TextSpan(
                text: "SincereSanta",
                style: footerSubtitleLinkStyle,
                recognizer: TapGestureRecognizer()
                ..onTap = () { launchUrlString(sincereSantaUrl);
                },
              ),
              const TextSpan(
                text: " and ",
                style: footerSubtitleTextStyle,
              ),
              TextSpan(
                text: "DarkStar1997",
                style: footerSubtitleLinkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () { launchUrlString(darkStar1997Url);
                  },
              ),
            ]
          )),
        ],
      ),
    );
  }

  Widget getPlotList(Size size) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: renderObjects!.length + 1,

        itemBuilder: (context, index) {
          if (index < renderObjects!.length) {
            final item = renderObjects![index];
            return getReportPlot(item);
          }

          return getFooter();
        },
      ),
    );

    // return getReportPlot(renderObjects![1]);
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


              if (renderObjects != null)
                Flex(
                  direction: Axis.vertical,
                  children: [
                    const SizedBox(height: 150),
                    getPlotList(size),
                  ],
                )
            ]
          )
        )
      ],
    );
  }
}