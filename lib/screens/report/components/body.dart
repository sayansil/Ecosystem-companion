import 'dart:io';
import 'dart:typed_data';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/database/database_manager.dart';
import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:ecosystem/schema/generated/plot_visualisation_generated.dart';
import 'package:ecosystem/utility/reportHelpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late String reportLocation;

  Future<void> loadData() async {
    if (widget.plotDataPath != null) {
      // Load from file in widget.plotDataPath
      File plotFile = File(join(reportLocation, widget.plotDataPath));
      plotBundleData = plotFile.readAsBytesSync();

      setState(() {
        plotBundle = PlotBundle(plotBundleData);
      });
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
    // Save plotBundle to file
    final fileName = "${DateFormat("report-dd.MM.yyyy-hh.mm.ss").format(currentTs)}.ftx";
    File binFile = File(join(reportLocation, fileName));

    binFile.writeAsBytes(plotBundleData);

    // Update metadata

    Uint8List newMetaData;

    final metaPath = join(reportLocation, metaDataFileName);
    File metaFile = File(metaPath);

    if (metaFile.existsSync()) {
      newMetaData = getMetaData(metaFile.readAsBytesSync(), fileName, currentTs.millisecondsSinceEpoch, plotBundle);
    } else {
      metaFile.createSync(recursive: true);
      newMetaData = getMetaData(null, fileName, currentTs.millisecondsSinceEpoch, plotBundle);
    }

    metaFile.writeAsBytesSync(newMetaData);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      loading = true;
    });

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        reportLocation = prefs.getString('textReportLocation') ?? "";
      });

      loadData().then((value) => {
        setState(() {
          loading = false;
        })
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Text("TODO");
  }
}