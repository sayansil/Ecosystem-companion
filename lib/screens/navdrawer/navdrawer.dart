import 'package:ecosystem/constants.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: colorPrimary,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 10),
            buildMenuItem(text: "Config", icon: Icons.code_rounded),
            const SizedBox(height: 10),
            buildMenuItem(text: "Settings", icon: Icons.settings_rounded),
            const SizedBox(height: 20),
            Divider(
              color: Colors.white30,
              endIndent: defaultPadding,
              indent: defaultPadding,
            ),
            const SizedBox(height: 20),
            buildMenuItem(text: "About", icon: Icons.info_rounded),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({required String text, required IconData icon}) {
    final color = Colors.white;
    final hoverColor = Colors.white10;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: defaultPadding),
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: () {},
    );
  }
}
