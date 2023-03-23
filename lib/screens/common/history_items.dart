import 'package:ecosystem/constants.dart';
import 'package:ecosystem/schema/generated/report_meta_visualisation_generated.dart';
import 'package:ecosystem/styles/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getSubtitle(List<String> subtitles, int createdTs){
  final species = subtitles.join(" | ");
  final dateTime = DateTime.fromMillisecondsSinceEpoch(createdTs);

  return "$species | ${DateFormat("d MMM y, h:mm a").format(dateTime)}";
}

ListTile historyReportItem(Meta item, viewReport, deleteReport) {
  return ListTile(
    contentPadding: const EdgeInsets.only(
      top: defaultPadding / 3,
      bottom: defaultPadding / 3,
      left: defaultPadding / 5,
      right: defaultPadding / 5,
    ),
    title: Text(
      item.title!,
      overflow: TextOverflow.ellipsis,
      style: historyItemTitleTextStyle,
    ),
    subtitle: Text(
      getSubtitle(item.subtiles!, item.createdTs),
      overflow: TextOverflow.ellipsis,
      style: historyItemSubtitleTextStyle,
    ),
    dense: false,
    focusColor: null,
    trailing: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility_rounded, color: colorSecondary),
          onPressed: () => viewReport(item.title),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: const Icon(Icons.delete_rounded, color: colorSecondary),
          onPressed: () => deleteReport(item.title),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        )
      ],
    ),
  );
}