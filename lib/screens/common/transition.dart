import 'package:flutter/material.dart';

PageRouteBuilder buildPageRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (c, a1, a2) => screen,
    transitionsBuilder: (c, anim, a2, child) =>
        FadeTransition(opacity: anim, child: child),
    transitionDuration: const Duration(milliseconds: 500),
  );
}

Future<void> cap120fps() async {
  await Future.delayed(const Duration(milliseconds: 8));
}
