import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';

Future<bool> showYesNoDialog(context, title, message, acceptBtn, rejectBtn) async {
  bool willLeave = false;
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        title,
        style: dialogTitleStyle,
      ),
      content: Text(
        message,
        style: dialogSubtitleStyle,
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(rejectBtn),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            foregroundColor: Colors.white,
            textStyle: dialogButtonStyle,
          ),
        ),
        TextButton(
          onPressed: () {
            willLeave = true;
            Navigator.of(context).pop();
          },
          child: Text(acceptBtn),
          style: TextButton.styleFrom(
            foregroundColor: colorPrimary,
            textStyle: dialogButtonStyle
          ),
        )
      ],
    ));
  return Future.value(willLeave);
}

