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
  int currentYear = 5;

  String getProgressText() {
    return currentYear.toString() + " / " + widget.years.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      padding: EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        bottom: defaultPadding,
        top: defaultPadding,
      ),
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: widget.years.toDouble(),
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color: colorSecondaryLight,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: currentYear.toDouble(),
              cornerStyle: CornerStyle.bothCurve,
              width: 0.2,
              color: colorPrimaryLight,
              sizeUnit: GaugeSizeUnit.factor,
            )
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
      ])
    );
  }
}
