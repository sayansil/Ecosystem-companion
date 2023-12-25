import 'package:ecosystem/screens/common/defaultappbar.dart';
import 'package:ecosystem/screens/report/components/body.dart';
import 'package:flutter/material.dart';

import 'components/body_landscape.dart';

class ReportScreen extends StatelessWidget {
  final String? plotDataPath;

  const ReportScreen(this.plotDataPath, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait ?
            ReportBody(plotDataPath) :
            ReportLandscapeBody(plotDataPath);
        }
      ),
  );
}