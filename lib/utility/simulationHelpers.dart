import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SimulationSet {
  String kingdom;
  String species;
  int count;

  SimulationSet(String kingdom, String species, int count)
      : kingdom = kingdom,
        species = species,
        count = count;

  static List<SimulationSet> fromString(String value) {
    final setList = jsonDecode(value) as List;

    List<SimulationSet> sets = [];
    setList.forEach((element) {
      final setElement = element as Map;
      sets.add(SimulationSet(
          setElement["kingdom"],
          setElement["species"],
          setElement["count"]
      ));
    });

    return sets;
  }

  static String asString(List<SimulationSet> sets) {
    List<Map<String, dynamic>> setList = [];

    sets.forEach((element) {
      setList.add({
        "kingdom": element.kingdom,
        "species": element.species,
        "count": element.count
      });
    });

    return jsonEncode(setList);
  }
}

enum SimulationStatus {
  ready,
  running,
  completed,
  stopped,
}

Future<String> getEcosystemRoot() async {
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  final ecosystemRoot = prefs.getString('ecosystemRoot') ?? "";

  return ecosystemRoot;
}
