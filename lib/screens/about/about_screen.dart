import 'package:ecosystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/screens/common/navdrawer.dart';
import 'package:ecosystem/screens/common/appbar.dart';
import 'components/body.dart';
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: NavigationDrawer(currentItem: DrawerItem.about),
        appBar: buildAppBar(context, ""),
        body: AboutBody(),
      );
}
