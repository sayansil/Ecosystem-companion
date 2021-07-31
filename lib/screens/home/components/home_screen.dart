import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                elevation:0,
                leading: IconButton(
                    icon: SvgPicture.asset("assets/images/menu.svg"),
                    onPressed:() {},
                ),
            ),
        );
    }
}
