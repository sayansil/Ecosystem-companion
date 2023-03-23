import 'dart:io';
import 'dart:typed_data';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/database/database_manager.dart';
import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:ecosystem/schema/generated/plot_visualisation_generated.dart';
import 'package:ecosystem/utility/reportHelpers.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class ReportBody extends StatefulWidget {
  final String? plotDataPath;

  const ReportBody(this.plotDataPath, {Key? key}): super(key: key);

  @override
  _ReportBodyState createState() => _ReportBodyState();
}

class _ReportBodyState extends State<ReportBody> {
  bool loading = true;
  late Uint8List plotBundleData;
  late PlotBundle plotBundle;

  Future<void> loadData() async {
    final ecosystemRoot = await getEcosystemRoot();

    if (widget.plotDataPath != null) {
      // Load from file in widget.plotDataPath
      File plotFile = File(join(ecosystemRoot, reportDir, widget.plotDataPath));

      if (plotFile.existsSync()) {
        plotBundleData = plotFile.readAsBytesSync();

        setState(() {
          plotBundle = PlotBundle(plotBundleData);
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
        plotBundle = PlotBundle(plotBundleData);
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
    binFile.writeAsBytes(plotBundleData);

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
          plotBundle
      );
    } else {
      // Create new meta
      metaFile.createSync(recursive: true);
      newMetaData = addMetaData(
          null,
          fileName,
          currentTs.millisecondsSinceEpoch,
          plotBundle
      );
    }

    metaFile.writeAsBytesSync(newMetaData);
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
    // TODO: implement build
    return const Text("TODO");
  }
}