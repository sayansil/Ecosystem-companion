import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/common/credits.dart';
import 'package:ecosystem/screens/common/header.dart';
import 'package:ecosystem/styles/widget_styles.dart';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutLandscapeBody extends StatefulWidget {
  const AboutLandscapeBody({super.key});

  @override
  State<AboutLandscapeBody> createState() => _AboutLandscapeBodyState();
}

class _AboutLandscapeBodyState extends State<AboutLandscapeBody> {
  String version = "";

  Future<void> loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    loadVersion();

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          // * Header background
          getScreenHeaderBackground(size),

          ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  end: Alignment.topCenter,
                  begin: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white.withOpacity(0.05)],
                  stops: const [0.95, 1],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: defaultPadding,
                  right: defaultPadding,
                ),
                physics: const BouncingScrollPhysics(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      // Title
                      getScreenHeaderText(screenTitleAbout),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: defaultCardShadow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              aboutText,
                              style: subHeaderStyle,
                            ),

                            const SizedBox(height: 100),

                            Visibility(
                              visible: version.isNotEmpty,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding / 4,
                                  horizontal: defaultPadding / 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "version: $version",
                                  style: subHeaderBrightStyle,
                                ),
                              ),
                            ),

                            getFooter(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ]
                ),
              )
          ),
        ],
      ),
    );
  }
}
