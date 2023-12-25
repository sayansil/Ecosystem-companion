import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/about/components/body_landscape.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/screens/common/navdrawer.dart';
import 'package:ecosystem/screens/common/navappbar.dart';
import 'components/body.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const NavDrawer(currentItem: DrawerItem.about),
        appBar: buildNavAppBar(context),
        body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.portrait ?
              const AboutBody() :
              const AboutLandscapeBody();
          }
        ),
      );
}
