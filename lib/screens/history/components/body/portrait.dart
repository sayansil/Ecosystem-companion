

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:ecosystem/constants.dart';
import 'package:ecosystem/screens/common/header.dart';
import 'package:ecosystem/screens/common/history_items.dart';
import 'driver.dart';

Widget getPortraitBody(HistoryBodyState state) {
  Size size = MediaQuery.of(state.context).size;

  return Container(
    constraints: const BoxConstraints.expand(),
    child: Stack(
      children: <Widget>[
        // * Header background
        getScreenHeaderBackground(size),

        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              // Title
              Container(
                padding: const EdgeInsets.only(
                  left: defaultPadding,
                  right: defaultPadding,
                ),
                child: getScreenHeaderText(screenTitleHistory),
              ),

              //* Report list
              Expanded(
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.only(
                    top: defaultPadding * 1.25,
                    left: defaultPadding * 0.75,
                    right: defaultPadding * 0.25,
                  ),
                  decoration: const BoxDecoration(
                    color: colorBackground,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      // Loading screen
                      Visibility(
                        visible: state.loading,
                        child: Lottie.asset(assetLoading),
                      ),

                      // Empty screen
                      Visibility(
                        visible: !state.loading && state.reportList.isEmpty,
                        child: Lottie.asset(assetEmpty),
                      ),

                      // Report List
                      Visibility(
                          visible: !state.loading && state.reportList.isNotEmpty,
                          child: SizedBox(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: state.reportList.length,
                              itemBuilder: (context, index) {
                                final item = state.reportList[index];
                                return historyReportItem(
                                    item,
                                    state.viewReport,
                                    state.deleteReport,
                                );
                              },
                              physics: const BouncingScrollPhysics(),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ]
        ),
      ],
    ),
  );
}