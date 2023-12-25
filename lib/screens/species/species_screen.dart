import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/species/components/body_landscape.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/screens/common/navdrawer.dart';
import 'package:ecosystem/screens/common/navappbar.dart';
import 'components/body.dart';

class SpeciesScreen extends StatelessWidget {
  const SpeciesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    drawer: const NavDrawer(currentItem: DrawerItem.organism),
    appBar: buildNavAppBar(context),
    body: OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return orientation == Orientation.portrait ?
          const SpeciesBody() :
          const SpeciesLandscapeBody();
      }
    ),
  );
}
