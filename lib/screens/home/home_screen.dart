import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ecosystem/screens/home/components/body.dart';

class HomeScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: buildAppBar(),
            body: Body(),
        );
    }

    AppBar buildAppBar() {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        return AppBar(
                elevation:0,
                brightness: Brightness.dark,
                leading: IconButton(
                    icon: SvgPicture.asset("assets/images/menu.svg"),
                    onPressed:() {},
                ),
            );
    }
}
