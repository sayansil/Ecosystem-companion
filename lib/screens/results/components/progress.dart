import 'dart:math';

import 'package:ecosystem/styles/widget_styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';

class ResultProgress extends StatefulWidget {
  final int years;
  final List<SimulationSet> initOrganisms;

  ResultProgress(this.years, this.initOrganisms, {Key? key}): super(key: key);

  @override
  _ResultProgressState createState() => _ResultProgressState();
}

class _ResultProgressState extends State<ResultProgress> {
  int currentYear = 1536;

  String getProgressText() {
    return currentYear.toString() + " / " + widget.years.toString();
  }

  @override
  Widget build(BuildContext context) {
    Size parentSize = MediaQuery.of(context).size;

    double progressDims = min(parentSize.width * 0.75, 500);
    double markerWidth = progressDims * 0.1;

    return Container(
      alignment: Alignment.topCenter,

      child: Container(
        height: progressDims,
        width: progressDims,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            axisLineStyle: AxisLineStyle(
              thickness: markerWidth,
              cornerStyle: CornerStyle.bothCurve,
              color: colorSecondaryLight,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: max(100 * currentYear.toDouble() / widget.years, 10),
                cornerStyle: CornerStyle.bothCurve,
                width: markerWidth,
                color: colorPrimaryLight,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Text(
                  getProgressText(),
                  style: progressTextStyle,
                ))
            ])
        ]))
    );
  }
}
