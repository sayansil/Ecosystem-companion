import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/common/defaultappbar.dart';
import 'package:ecosystem/screens/common/dialog.dart';
import 'package:ecosystem/screens/results/components/progress.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int year;
  final List<SimulationSet> initOrganisms;

  ResultScreen(this.year, this.initOrganisms, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () => showYesNoDialog(
          context,
          stopSimulationTitle,
          stopSimulationMessage,
          stopSimulationAccept,
          stopSimulationReject
      ),
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: ResultProgress(this.year, this.initOrganisms),
  ));
}
