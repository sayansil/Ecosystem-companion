import 'package:flutter/material.dart';

PageRouteBuilder buildPageRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (c, a1, a2) => screen,
    transitionsBuilder: (c, anim, a2, child) =>
        FadeTransition(opacity: anim, child: child),
    transitionDuration: Duration(milliseconds: 500),
  );
}
