import 'package:ecosystem/screens/about/components/body/portrait.dart';
import 'package:ecosystem/screens/about/components/body/landscape.dart';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutBody extends StatefulWidget {
  const AboutBody({super.key});

  @override
  State<AboutBody> createState() => AboutBodyState();
}

class AboutBodyState extends State<AboutBody> {
  String version = "";

  Future<void> loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait ?
          getPortraitBody(this) :
          getLandscapeBody(this);
        }
    );
  }
}
