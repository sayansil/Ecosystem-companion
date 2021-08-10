import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ecosystem/screens/navdrawer/navdrawer.dart';
import 'package:ecosystem/screens/home/components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: NavigationDrawer(),
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      brightness: Brightness.dark,
      leading: Builder(
        builder: (context) => IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: SvgPicture.asset("assets/images/menu.svg"),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }
}
