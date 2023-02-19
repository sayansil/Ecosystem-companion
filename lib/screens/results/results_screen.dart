import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/results/components/progress.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class ResultScreen extends StatelessWidget {
  final int year;
  final List<SimulationSet> initOrganisms;

  ResultScreen(this.year, this.initOrganisms, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    body: ResultProgress(this.year, this.initOrganisms),
  );
}
