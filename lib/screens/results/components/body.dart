import 'progress.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';

class ResultBody extends StatefulWidget {
  final int years;
  final List<SimulationSet> initOrganisms;

  ResultBody(this.years, this.initOrganisms, {Key? key}): super(key: key);

  @override
  _ResultBodyState createState() => _ResultBodyState();
}

class _ResultBodyState extends State<ResultBody> {
  String getText() {
    return widget.years.toString() + " years with " + widget.initOrganisms.length.toString() + " species types.";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 600,
      child: Row(
        children: <Widget>[
          Text(
            getText(),
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
