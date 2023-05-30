import 'package:ecosystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecosystem/screens/home/home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const CompanionApp());
}

class CompanionApp extends StatelessWidget {
  const CompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecosystem Simulator - Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorPrimary,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: colorSecondary),
        scaffoldBackgroundColor: colorBackground,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
