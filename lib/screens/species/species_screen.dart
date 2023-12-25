import 'package:ecosystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/screens/common/navdrawer.dart';
import 'package:ecosystem/screens/common/navappbar.dart';
import 'components/body/driver.dart';

class SpeciesScreen extends StatelessWidget {
  const SpeciesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    drawer: const NavDrawer(currentItem: DrawerItem.organism),
    appBar: buildNavAppBar(context),
    body: const SpeciesBody(),
  );
}
