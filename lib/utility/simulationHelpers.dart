import 'dart:convert';
import 'dart:io';

import 'package:ecosystem/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
  Directory appDocDir = await getApplicationDocumentsDirectory();
  final String ecosystemRoot = join(appDocDir.path, ecosystemDir);

  return ecosystemRoot;
}

enum KingdomName {
  animal("animal"),
  plant("plant");

  const KingdomName(this.value);
  final String value;
}

int getKingdomIndex(String kingdomName) {
  switch (kingdomName) {
    case "animal": return 0;
    case "plant": return 1;
  }

  return -1;
}
