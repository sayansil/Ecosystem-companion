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