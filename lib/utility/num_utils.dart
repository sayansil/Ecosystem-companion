import 'dart:math';

String roundNumber(num n, int decimal) {
  double number = n.toDouble();

  final significantFigures = (number * pow(10, decimal)).toInt();
  final accurateFigures = significantFigures.toDouble() / pow(10, decimal);

  var numText = "$accurateFigures";

  if (accurateFigures.toInt() == accurateFigures) {
    numText = "${accurateFigures.toInt()}";
  }

  return numText;
}

String shrinkNumber(num n, [decimal=0]) {
  double number = n.toDouble();
  String numText;

  if (number >= 1000000) {
    numText = "${roundNumber(number / 1000000, decimal)}M";
  } else if (number >= 1000) {
    numText = "${roundNumber(number / 1000, decimal)}K";
  } else {
    numText = roundNumber(number, decimal);
  }

  return numText;
}

double runningAverage(double currentAverage, double value, num count) {
  return currentAverage + (value - currentAverage) / count;
}