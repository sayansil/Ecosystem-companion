import 'dart:io';
import 'dart:typed_data';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/database/database_manager.dart';
import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:ecosystem/schema/plot_visualisation_generated.dart';
import 'package:ecosystem/screens/common/credits.dart';
import 'package:ecosystem/screens/common/plot_item.dart';
import 'package:ecosystem/screens/report/components/body/landscape.dart';
import 'package:ecosystem/screens/report/components/body/portrait.dart';
import 'package:ecosystem/utility/report_helpers.dart' as report;
import 'package:ecosystem/utility/simulation_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';


class ReportBody extends StatefulWidget {
  final String? plotDataPath;

  const ReportBody(this.plotDataPath, {Key? key}): super(key: key);

  @override
  State<ReportBody> createState() => ReportBodyState();
}

class ReportBodyState extends State<ReportBody> {
  bool loading = true;
  Uint8List? plotBundleData;
  PlotBundle? plotBundle;
  List<report.RenderObject>? renderObjects;

  String? activeSpecies;
  String? activeKingdom;
  List<Plot> activePlots = [];

  Future<void> loadData(BuildContext context) async {
    final ecosystemRoot = await getEcosystemRoot();

    if (widget.plotDataPath != null) {
      // Load from file in widget.plotDataPath
      File plotFile = File(join(ecosystemRoot, reportDir, widget.plotDataPath));

      if (plotFile.existsSync()) {
        plotBundleData = plotFile.readAsBytesSync();
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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

  Future<void> saveData(BuildContext context) async {
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

  Widget getPlotList(Size size) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: renderObjects!.length + 1,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if (index < renderObjects!.length) {
            final item = renderObjects![index];
            return getReportPlot(item);
          }

          return getFooter();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      loading = true;
    });

    loadData(this.context).then((value) => {
      setState(() {
        loading = false;
      })
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