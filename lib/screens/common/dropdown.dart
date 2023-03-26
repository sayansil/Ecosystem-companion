import 'package:ecosystem/constants.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';

class DropdownObject {
  String text = "";
  String value = "";

  DropdownObject(this.value, this.text);
  DropdownObject.common(commonValue) {
    text = commonValue;
    value = commonValue;
  }
}

Widget getDropDown(onChanged, List<DropdownObject> itemList, label, defaultValue) {
  return DropdownButtonFormField<String>(
    isExpanded: true,
    icon: const Icon(Icons.arrow_downward_rounded),
    elevation: 20,
    style: dropdownOptionStyle,
    onChanged: onChanged,
    items: itemList.map((e) => DropdownMenuItem<String>(
      value: e.value,
      child: Text(
        e.text,
        overflow: TextOverflow.ellipsis,
      ),
    )).toList(),
    value: defaultValue,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: editTextStyle,
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: colorSecondary)
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: colorSecondary)
      ),
    ),
  );
}