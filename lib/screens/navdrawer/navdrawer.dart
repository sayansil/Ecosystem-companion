import 'package:ecosystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/screens/home/home_screen.dart';
import 'package:ecosystem/screens/config/config_screen.dart';
import 'package:ecosystem/screens/about/about_screen.dart';
import 'package:ecosystem/screens/settings/settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawer extends StatelessWidget {
  final String? currentScreen;

  NavigationDrawer({required String? currentScreen})
      : currentScreen = currentScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: colorPrimary,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 10),
            buildMenuItem(
                text: "Home",
                icon: Icons.home_rounded,
                onClicked: () => selectedItem(context, 0)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: "Config",
                icon: Icons.code_rounded,
                onClicked: () => selectedItem(context, 1)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: "Settings",
                icon: Icons.settings_rounded,
                onClicked: () => selectedItem(context, 2)),
            const SizedBox(height: 20),
            Divider(
              color: Colors.white30,
              endIndent: defaultPadding,
              indent: defaultPadding,
            ),
            const SizedBox(height: 20),
            buildMenuItem(
                text: "About",
                icon: Icons.info_rounded,
                onClicked: () => selectedItem(context, 3)),
            const SizedBox(height: 20),
            buildMenuItem(
                text: "Contribute",
                icon: Icons.code_rounded,
                onClicked: () => selectedItem(context, 4)),
          ],
        ),
      ),
    );
  }

  _launchURL({required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  VoidCallback? selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 1:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ConfigScreen()));
        break;
      case 2:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SettingsScreen()));
        break;
      case 3:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AboutScreen()));
        break;
      case 4:
        _launchURL(url: githubUrl);
        break;
      default:
    }
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    final color = Colors.white;
    final hoverColor = Colors.white10;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: defaultPadding),
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}
