import 'dart:math';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:ecosystem/utility/reportHelpers.dart' as report_helper;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<FlSpot> getReportLineData(List x, List y) {
  List<FlSpot> lineData = [];

  for (int i = 0; i < x.length; i++) {
    lineData.add(
        FlSpot(x[i].toDouble(), y[i].toDouble())
    );
  }

  return lineData;
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  int roundValue = value.toInt();
  Widget text = Text("$roundValue", style: plotTickStyle);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(
    double value,
    TitleMeta meta,
    double minY,
    double maxY,
    double interval) {
  final needsPrecision = maxY - minY < 5;

  String textValue;

  if (value >= 1000000) {
    textValue = "${(value / 1000000).toStringAsFixed(needsPrecision? 2 : 1)}M";
  } else if (value >= 1000) {
    textValue = "${(value / 1000).toStringAsFixed(needsPrecision? 2 : 1)}K";
  } else {
    textValue = value.toStringAsFixed(needsPrecision? 2 : 0);
  }

  // Ignore value if too close to ends
  if (value != minY && value < minY + interval) {
    textValue = "";
  }
  if (value != maxY && value > maxY - interval) {
    textValue = "";
  }

  final text = Text(textValue, style: plotTickStyle, textAlign: TextAlign.right);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    angle: 5.5,
    space: 5,
    child: text,
  );
}

List<LineTooltipItem> getTooltips(List<LineBarSpot> spots) {
  List<LineTooltipItem> toolTips = [];

  for (int spotIndex = 0; spotIndex < spots.length; spotIndex++) {
    final spot = spots[spotIndex];
    final spotColor = plotLineColors[spotIndex];

    toolTips.add(
        LineTooltipItem(
            "${spot.y}",
            TextStyle(
                color: spotColor,
                fontSize: 14, fontFamily: 'Poppins',
                fontWeight: FontWeight.bold
            )
        )
    );
  }

  return toolTips;
}

Widget getLegendItem(text, color) {
  final style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: color,
  );
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Text(text, style: style),
  );
}

Widget getPlotHeader(String title, Map lines) {

  final lineTitles = lines.keys.toList();

  final textTitle = Text(title, style: plotTitleStyle);
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      textTitle,
      if (lineTitles.length > 1) Align(
        alignment: Alignment.center,
          child: SizedBox(
            height: 40,
            child:ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 5),
              scrollDirection: Axis.horizontal,
              itemCount: lineTitles.length,
              itemBuilder: (context, index) {
                final legendText = lineTitles[index];
                final legendColor = plotLineColors[index];
                return getLegendItem(legendText, legendColor);
              }
          ),
        ),
      )
    ],
  );
}

Widget getReportPlot(report_helper.RenderObject object) {
  const xLabel = "Years";
  final yLabel = object.label;
  final lines = object.lines;
  final title = object.title;

  final xRange = [
    for (var i = 1; i <= lines.values.first.length; i++) i
  ];

  List<LineChartBarData> plotLines = [];

  var minX = 0.0;
  var maxX = lines.values.first.length.toDouble();
  var minY = double.infinity;
  var maxY = double.negativeInfinity;

  final lineTitles = lines.keys.toList();

  for (var lineIndex = 0; lineIndex < lineTitles.length; lineIndex++) {
    final lineTitle = lineTitles[lineIndex];
    final lineValues = lines[lineTitle]!;

    var currentMin = lineValues.reduce(min);
    var currentMax = lineValues.reduce(max);

    if (currentMin < minY) {
      minY = currentMin;
    }
    if (currentMax > maxY) {
      maxY = currentMax;
    }

    var lineColor = plotLineColors[lineIndex];

    plotLines.add(
      LineChartBarData(
        isCurved: true,
        barWidth: 3,
        color: lineColor,
        spots: getReportLineData(xRange, lineValues),
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      )
    );
  }

  final leftInterval = max(1, (maxY - minY) / 4).toDouble();
  final rightInterval = max(1, (maxX - minX) / 5).toDouble();

  return Container(
    padding: const EdgeInsets.only(
      left: defaultPadding / 3,
      right: defaultPadding,
      top: defaultPadding
    ),
    height: 350,
    child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: false,
            drawVerticalLine: false,
            drawHorizontalLine: false,
          ),

          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              axisNameSize: 60,
              axisNameWidget: getPlotHeader(title, lines),
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(yLabel, style: plotLabelStyle),
              axisNameSize: 20,
              sideTitles: SideTitles(
                reservedSize: 45,
                showTitles: true,
                interval: leftInterval,
                getTitlesWidget: (value, meta) => leftTitleWidgets(
                    value, meta, minY, maxY, leftInterval
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(xLabel, style: plotLabelStyle),
              axisNameSize: 10,
              sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
                interval: rightInterval,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
          ),

          borderData: FlBorderData(
            show: false,
          ),

          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,

          lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: colorBackgroundSeeThrough,
                  getTooltipItems: getTooltips
              )
          ),

          lineBarsData: plotLines,
        ),
        swapAnimationDuration: const Duration(milliseconds: 8), // Optional
        swapAnimationCurve: Curves.linear,
    )
  );
}