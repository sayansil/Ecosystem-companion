
import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Widget getFooter() {
  return Container(
    alignment: Alignment.topLeft,
    padding: const EdgeInsets.only(
      left: defaultPadding / 2,
      right: defaultPadding / 2,
      top: 100,
      bottom: defaultPadding,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(footerTitleText, style: footerTitleTextStyle),
        RichText(text: TextSpan(
            children: [
              const TextSpan(
                text: "by ",
                style: footerSubtitleTextStyle,
              ),
              TextSpan(
                text: "SincereSanta",
                style: footerSubtitleLinkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () { launchUrlString(sincereSantaUrl);
                  },
              ),
              const TextSpan(
                text: " and ",
                style: footerSubtitleTextStyle,
              ),
              TextSpan(
                text: "DarkStar1997",
                style: footerSubtitleLinkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () { launchUrlString(darkStar1997Url);
                  },
              ),
            ]
        )),
      ],
    ),
  );
}