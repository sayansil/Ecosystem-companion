import 'package:ecosystem/screens/common/defaultappbar.dart';
import 'package:ecosystem/screens/report/components/body/driver.dart';
import 'package:flutter/material.dart';


class ReportScreen extends StatelessWidget {
  final String? plotDataPath;

  const ReportScreen(this.plotDataPath, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: ReportBody(plotDataPath)
  );
}