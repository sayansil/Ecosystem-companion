import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:flutter/services.dart';

class Body extends StatefulWidget {
    @override
    _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

    bool correctKingdom = false;
    bool correctSpecies = false;
    bool correctCount = false;

    final textKingdomController = TextEditingController();
    final textSpeciesController = TextEditingController();
    final textCountController = TextEditingController();

    @override
    void dispose() {
        textKingdomController.dispose();
        textSpeciesController.dispose();
        super.dispose();
    }

    void valueChanged(String valueType) {
        setState(() {
            if (valueType == "kingdom" || valueType == "species") {
                String kingdom = textKingdomController.text.toLowerCase();
                String species = textSpeciesController.text.toLowerCase();

                correctKingdom = false;
                correctSpecies = false;

                var speciesList = demoSpeciesList;
                if (speciesList.containsKey(kingdom)) {
                    correctKingdom = true;

                    if (speciesList[kingdom]!.contains(species)) {
                        correctSpecies = true;
                    }
                }
            } else if (valueType == "count") {
                int count = int.tryParse(textCountController.text) ?? 0;

                correctCount = false;

                if (count > 0) {
                    correctCount = true;
                }
            }
        });
    }

    bool isReady() {
        return  correctSpecies &&
                correctKingdom &&
                correctCount;
    }

    @override
    Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;

        return Container(
                    height: double.infinity,
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
                                top: size.height*0.3 - 150,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 250,
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
                                                            ),
                                                            onChanged: (text) { valueChanged("kingdom"); },
                                                            controller: textKingdomController,
                                                        ),
                                                    ),
                                                    Visibility(
                                                        child: Icon(
                                                            Icons.check_rounded,
                                                            color: Colors.green,
                                                            size: 30.0,
                                                        ),
                                                        visible: correctKingdom,
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
                                                            ),
                                                            onChanged: (text) { valueChanged("species"); },
                                                            controller: textSpeciesController,
                                                        ),
                                                    ),
                                                    Visibility(
                                                        child: Icon(
                                                            Icons.check_rounded,
                                                            color: Colors.green,
                                                            size: 30.0,
                                                        ),
                                                        visible: correctSpecies,
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
                                                            keyboardType: TextInputType.number,
                                                            inputFormatters: <TextInputFormatter>[
                                                                FilteringTextInputFormatter.digitsOnly
                                                            ],
                                                            decoration: InputDecoration(
                                                                labelText: "Count",
                                                                labelStyle: TextStyle(color: colorPrimary.withOpacity(0.5)),
                                                                enabledBorder: InputBorder.none,
                                                                focusedBorder: InputBorder.none,
                                                            ),
                                                            onChanged: (text) { valueChanged("count"); },
                                                            controller: textCountController,
                                                        ),
                                                    ),
                                                    Visibility(
                                                        child: Icon(
                                                            Icons.check_rounded,
                                                            color: Colors.green,
                                                            size: 30.0,
                                                        ),
                                                        visible: correctCount,
                                                    ),
                                                ]
                                            ),
                                        ]
                                    ),
                                )
                            ),

                            Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: colorPrimary,
                                        textStyle: const TextStyle(fontSize: 20),
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0), // <-- Radius
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: defaultPadding / 1.5),
                                    ),
                                    onPressed: isReady() ? () {} : null,
                                    child: const Text('SIMULATE'),
                                ),
                            ),
                        ],
                    )
                );
    }
}
