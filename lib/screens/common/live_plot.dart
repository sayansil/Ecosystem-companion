import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'list_utils.dart';

List<Color> gradientColors = [
  colorSecondary,
  colorPrimary,
];

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  int roundValue = value.toInt();
  Widget text = Text("$roundValue", style: style);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  int roundValue = value.toInt();

  String text;

  if (roundValue >= 1000000) {
    text = "${(roundValue / 1000000).round()}M";
  } else if (roundValue >= 1000) {
    text = "${(roundValue / 1000).round()}K";
  } else {
    text = "$roundValue";
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}


List<FlSpot> getLineData(List<int> x, List<int> y, [int? maxX, int? maxY]) {
  List<FlSpot> lineData = [];

  for (int i = 0; i < x.length; i++) {
    lineData.add(
        FlSpot(x[i].toDouble(), y[i].toDouble())
    );
  }

  return lineData;
}

List<LineTooltipItem> getTooltips(List<LineBarSpot> spots) {
  return spots.map((LineBarSpot touchedSpot) {
    return LineTooltipItem(
        "population: ${touchedSpot.y.toInt()}\nyear: ${touchedSpot.x.toInt()}",
        chartTooltipTextStyle
    );
  }).toList();
}

LineChartData liveData(
    List<int> x,
    List<int> y,
    [double? maxX, double? maxY]
    ) {

  double minX = 1;
  double minY = 0;
  if (maxX == null) {
    var minMaxX = minMaxList(x);
    maxX = minMaxX.isNotEmpty ? minMaxX[1].toDouble() : minX;
  }
  if (maxY == null) {
    var minMaxY = minMaxList(y);
    maxY = minMaxY.isNotEmpty ? minMaxY[1].toDouble() : minY;
  }

  return LineChartData(
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
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
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
            tooltipBgColor: colorPrimary,
            getTooltipItems: getTooltips
        )
    ),

    lineBarsData: [
      LineChartBarData(
        spots: getLineData(x, y),
        isCurved: true,
        gradient: LinearGradient(
          colors: gradientColors,
        ),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: gradientColors
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ),
    ],
  );
}