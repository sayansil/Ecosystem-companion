import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';

class Body extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;

        return Column(
            children: <Widget>[
                Container(
                    height: size.height*0.2,
                    child: Stack(
                        children: <Widget>[
                            Container(
                                height: size.height*0.2 - 27,
                                decoration: BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(36),
                                        bottomRight: Radius.circular(36),
                                    ),
                                ),
                            ),

                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 54,
                                    margin: EdgeInsets.symmetric(horizontal: defaultPadding),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 10),
                                                blurRadius: 50,
                                                color: colorPrimary.withOpacity(0.23),
                                            ),
                                        ],
                                    ),
                                )
                            ),
                        ],
                    )
                ),
            ],
        );
    }
}
