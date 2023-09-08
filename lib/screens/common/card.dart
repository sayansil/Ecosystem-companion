import 'dart:math';
import 'dart:ui';

Size getCardDims(Size parentSize) {
  double w = max(600, parentSize.width * 0.5);
  double h = 100;

  return Size(w, h);
}