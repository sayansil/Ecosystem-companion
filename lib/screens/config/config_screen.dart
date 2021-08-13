import 'package:ecosystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/screens/common/navdrawer.dart';
import 'package:ecosystem/screens/common/appbar.dart';
import 'components/body.dart';

class ConfigScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: NavigationDrawer(currentItem: DrawerItem.config),
        appBar: buildAppBar(context, ""),
        body: ConfigBody(),
      );
}
