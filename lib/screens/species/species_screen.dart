import 'package:ecosystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/screens/common/navdrawer.dart';
import 'package:ecosystem/screens/common/navappbar.dart';
import 'components/body.dart';

class SpeciesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    drawer: NavDrawer(currentItem: DrawerItem.about),
    appBar: buildNavAppBar(context),
    body: SpeciesBody(),
  );
}
