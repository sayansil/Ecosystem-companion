import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/common/transition.dart';
import 'package:ecosystem/screens/species/species_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecosystem/screens/home/home_screen.dart';
import 'package:ecosystem/screens/about/about_screen.dart';
import 'package:ecosystem/screens/history/history_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NavDrawer extends StatelessWidget {
  final DrawerItem? currentItem;

  const NavDrawer({super.key, this.currentItem});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: colorPrimary,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 50),
            buildMenuItem(
                text: "Home",
                icon: Icons.home_rounded,
                onClicked: () => (currentItem == DrawerItem.home)
                    ? {Navigator.of(context).pop()}
                    : selectedItem(context, DrawerItem.home)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: "New species",
                icon: Icons.add,
                onClicked: () => (currentItem == DrawerItem.organism)
                    ? {Navigator.of(context).pop()}
                    : selectedItem(context, DrawerItem.organism)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: "History",
                icon: Icons.checklist_rtl_rounded,
                onClicked: () => (currentItem == DrawerItem.history)
                    ? {Navigator.of(context).pop()}
                    : selectedItem(context, DrawerItem.history)),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.white30,
              endIndent: defaultPadding,
              indent: defaultPadding,
            ),
            const SizedBox(height: 20),
            buildMenuItem(
                text: "About",
                icon: Icons.info_rounded,
                onClicked: () => (currentItem == DrawerItem.about)
                    ? {Navigator.of(context).pop()}
                    : selectedItem(context, DrawerItem.about)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: "Contribute",
                icon: Icons.rocket_rounded,
                onClicked: () => (currentItem == DrawerItem.contribute)
                    ? {Navigator.of(context).pop()}
                    : selectedItem(context, DrawerItem.contribute)),
          ],
        ),
      ),
    );
  }

  _launchURL({required String url}) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  VoidCallback? selectedItem(BuildContext context, DrawerItem item) {
    Navigator.of(context).pop();
    switch (item) {
      case DrawerItem.home:
        Navigator.push(context, buildPageRoute(const HomeScreen()));
        break;
      case DrawerItem.organism:
        Navigator.push(context, buildPageRoute(const SpeciesScreen()));
        break;
      case DrawerItem.history:
        Navigator.push(context, buildPageRoute(const HistoryScreen()));
        break;
      case DrawerItem.about:
        Navigator.push(context, buildPageRoute(const AboutScreen()));
        break;
      case DrawerItem.contribute:
        _launchURL(url: githubUrl);
        break;
      default:
    }
    return null;
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const color = Colors.white;
    const hoverColor = Colors.white10;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color, fontFamily: 'Poppins')),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}
