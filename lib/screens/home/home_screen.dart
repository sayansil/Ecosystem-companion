import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/common/navappbar.dart';
import 'package:ecosystem/screens/common/navdrawer.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const NavDrawer(currentItem: DrawerItem.home),
        appBar: buildNavAppBar(context),
        body: const HomeBody(),
      );
}
