import 'package:flutter/material.dart';
import 'package:ecosystem/constants.dart';
import 'package:flutter/services.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';

class Body extends StatefulWidget {
    @override
    _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

    bool correctKingdom = false;
    bool correctSpecies = false;
    bool correctCount = false;
    bool correctYears = false;

    final textKingdomController = TextEditingController();
    final textSpeciesController = TextEditingController();
    final textCountController = TextEditingController();
    final textYearsController = TextEditingController();

    var allSets = [];
    int years = 0;

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
            } else if (valueType == "years") {
                int years = int.tryParse(textYearsController.text) ?? 0;

                correctYears = false;

                if (years > 0) {
                    correctYears = true;
                }
            }
        });
    }

    void addSet() {
        if (isValidSet()) {
            setState((){
                allSets.add(
                    SimulationSet(
                        textKingdomController.text.toLowerCase(),
                        textSpeciesController.text.toLowerCase(),
                        int.tryParse(textCountController.text) ?? 0
                    )
                );

                textKingdomController.clear();
                textSpeciesController.clear();
                textCountController.clear();
            });
            valueChanged('kingdom');
            valueChanged('species');
            valueChanged('count');
        }
    }

    void clearSets() {
        setState(() {
            allSets = [];
        });
    }

    bool isReady() {
        return allSets.isNotEmpty && correctYears;
    }

    bool isValidSet() {
        return  correctSpecies &&
                correctKingdom &&
                correctCount;
    }

    @override
    Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;

        return Container(
                    constraints: BoxConstraints.expand(),
                    child: Stack(
                        children: <Widget>[
                            Container(
                                height: size.height*0.3,
                                decoration: BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(36),
                                        bottomRight: Radius.circular(36),
                                    ),
                                ),
                            ),

                            Container(
                                margin: EdgeInsets.only(
                                    left: defaultPadding,
                                    right: defaultPadding,
                                    top: size.height*0.3 + 140,
                                ),
                                child: GridView.builder(
                                    physics:BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(top: 40, bottom: size.height*0.1),
                                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20
                                    ),
                                    itemCount: allSets.isNotEmpty ? allSets.length + 1 : 0,
                                    itemBuilder: (BuildContext context, index) {
                                        return index < allSets.length ? Container(
                                            child: Stack(children: <Widget>[
                                                Positioned(
                                                    top: 10, left: 15, right: 15,
                                                    child: Container(
                                                        child: Text(
                                                            allSets[index].species,
                                                            style: TextStyle(fontSize: 30),
                                                        ),
                                                    ),
                                                ),
                                                Positioned(
                                                    top: 50, left: 15, right: 15,
                                                    child: Container(
                                                        child: Text(
                                                            allSets[index].kingdom,
                                                            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                                                        ),
                                                    ),
                                                ),
                                                Positioned(
                                                    bottom: 10, right: 15,
                                                    child: Container(
                                                        child: Text(
                                                            allSets[index].count.toString(),
                                                            style: TextStyle(fontSize: 25),
                                                        ),
                                                    ),
                                                ),
                                            ]),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                        ) : Container(
                                            alignment: Alignment.center,
                                            child: IconButton(
                                                icon: const Icon(Icons.delete),
                                                color: colorSecondary,
                                                iconSize: 35,
                                                onPressed:(){ clearSets();  },
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                        );
                                    },
                                ),
                            ),

                            Positioned(
                                top: size.height*0.3 - 210,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 100,
                                    margin: EdgeInsets.symmetric(horizontal: defaultPadding),
                                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                    decoration: BoxDecoration(
                                        color: colorPrimaryLight,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20), topRight: Radius.circular(20)
                                        ),
                                        boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 10),
                                                blurRadius: 50,
                                                color: colorPrimary.withOpacity(0.23),
                                            ),
                                        ],
                                    ),
                                    child: TextField(
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white.withOpacity(0.8)
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                            labelText: "Years to Simulate",
                                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                        ),
                                        onChanged: (text) { valueChanged("years"); },
                                        controller: textYearsController,
                                    ),
                                ),
                            ),

                            Positioned(
                                top: size.height*0.3 - 150,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 300,
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
                                            ElevatedButton(
                                                onPressed: isValidSet() ? () { addSet(); } : null,
                                                child: Text('ADD'),
                                                style: ElevatedButton.styleFrom(
                                                    primary: colorPrimary,
                                                    textStyle: const TextStyle(fontSize: 16),
                                                    minimumSize: Size(double.infinity, 30),
                                                    onPrimary: Colors.white,
                                                    shape: StadiumBorder(),
                                                    padding: EdgeInsets.symmetric(vertical: defaultPadding / 1.5),
                                                ),
                                            ),
                                            const SizedBox(
                                                height: 10.0,
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
