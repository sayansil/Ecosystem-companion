import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/common/credits.dart';
import 'package:ecosystem/screens/common/header.dart';
import 'package:ecosystem/styles/widget_styles.dart';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutBody extends StatefulWidget {
  const AboutBody({super.key});

  @override
  State<AboutBody> createState() => _AboutBodyState();
}

class _AboutBodyState extends State<AboutBody> {
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

          Container(
            padding: const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
            ),
            child: ShaderMask(
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                aboutText,
                                style: subHeaderStyle,
                              ),

                              const SizedBox(height: 100),

                              Visibility(
                                visible: version.isNotEmpty,
                                child: Text(
                                  "version: $version",
                                  style: subHeaderStyle,
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
            )
          ),
        ],
      ),
    );
  }
}
