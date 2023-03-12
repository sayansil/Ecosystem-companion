import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';

Future<bool> showYesNoDialog(
    context, title, message, acceptBtn, rejectBtn, {defaultYes = true}) async {
  bool userInput = false;
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
          onPressed: () {
            userInput = defaultYes;
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            foregroundColor: Colors.white,
            textStyle: dialogButtonStyle,
          ),
          child: Text(defaultYes? acceptBtn : rejectBtn),
        ),

        TextButton(
          onPressed: () {
            userInput = !defaultYes;
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: colorPrimary,
            textStyle: dialogButtonStyle
          ),
          child: Text(defaultYes? rejectBtn : acceptBtn),
        )
      ],
    ));
  return Future.value(userInput);
}

