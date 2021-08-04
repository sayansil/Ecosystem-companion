import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';

class Body extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;

        return Column(
            children: <Widget>[
                Container(
                    height: size.height*0.3,
                    child: Stack(
                        children: <Widget>[
                            Container(
                                height: size.height*0.3 - 75,
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
                                    height: 150,
                                    margin: EdgeInsets.symmetric(horizontal: defaultPadding),
                                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
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
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                    Flexible(
                                                        child: TextField(
                                                            style: TextStyle(
                                                                fontSize: 20.0,
                                                            ),
                                                            decoration: InputDecoration(
                                                                labelText: "Kingdom",
                                                                labelStyle: TextStyle(color: colorPrimary.withOpacity(0.5)),
                                                                enabledBorder: InputBorder.none,
                                                                focusedBorder: InputBorder.none,
                                                            )
                                                        ),
                                                    ),
                                                    Icon(
                                                        Icons.check_rounded,
                                                        color: Colors.green,
                                                        size: 30.0,
                                                    ),
                                                ]
                                            ),
                                            const Divider(
                                                height: 0,
                                                thickness:1,
                                            ),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                    Flexible(
                                                        child: TextField(
                                                            style: TextStyle(
                                                                fontSize: 20.0,
                                                            ),
                                                            decoration: InputDecoration(
                                                                labelText: "Species",
                                                                labelStyle: TextStyle(color: colorPrimary.withOpacity(0.5)),
                                                                enabledBorder: InputBorder.none,
                                                                focusedBorder: InputBorder.none,
                                                            )
                                                        ),
                                                    ),
                                                    Icon(
                                                        Icons.check_rounded,
                                                        color: Colors.green,
                                                        size: 30.0,
                                                    ),
                                                ]
                                            ),
                                        ]
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
