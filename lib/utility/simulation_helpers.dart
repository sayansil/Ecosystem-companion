import 'dart:convert';
import 'dart:io';

import 'package:ecosystem/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SimulationSet {
  String kingdom;
  String species;
  int count;
  int age;

  SimulationSet(this.kingdom, this.species, this.count, this.age);

  static List<SimulationSet> fromString(String value) {
    final setList = jsonDecode(value) as List;

    List<SimulationSet> sets = [];
    for (var element in setList) {
      final setElement = element as Map;
      sets.add(SimulationSet(
          setElement["kingdom"],
          setElement["species"],
          setElement["count"],
          setElement["age"]
      ));
    }

    return sets;
  }

  static String asString(List<SimulationSet> sets) {
    List<Map<String, dynamic>> setList = [];

    for (var element in sets) {
      setList.add({
        "kingdom": element.kingdom,
        "species": element.species,
        "count": element.count,
        "age": element.age,
      });
    }

    return jsonEncode(setList);
  }

  static Future<bool> isValidSets(List<SimulationSet> sets) async {
    final speciesMap = await getEligibleSpeciesMap();

    for (SimulationSet set in sets) {
      if (set.age < 0 || // Invalid age
          set.count < 0 || // Invalid count
          !speciesMap.containsKey(set.kingdom) || // Kingdom does not exist
          speciesMap[set.kingdom] == null || // No species in that kingdom
          !speciesMap[set.kingdom]!.contains(set.species)) { // Species does not exist
        return false;
      }
    }
    return true;
  }
}

enum SimulationStatus {
  init,
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

Future<Map<String, List<String>>> getEligibleSpeciesMap() async {
  Map<String, List<String>> speciesMap = {};

  final ecosystemRoot = await getEcosystemRoot();
  final ecosystemDataDir = Directory(join(ecosystemRoot, templateDir));

  if (ecosystemDataDir.existsSync()) {
    final children = await ecosystemDataDir.list().toList();
    final Iterable<Directory> dirs = children.whereType<Directory>();
    final List<String> kingdomNames = dirs.map((e) => basename(e.path)).toList();

    for (String dirName in kingdomNames) {
      final ecosystemKingdomDir = Directory(join(ecosystemRoot, templateDir, dirName));
      final children = await ecosystemKingdomDir.list().toList();
      final Iterable<Directory> dirs = children.whereType<Directory>();
      final List<String> speciesNames = dirs.map((e) => basename(e.path)).toList();

      speciesMap[dirName] = speciesNames;
    }
  }

  return speciesMap;
}

enum KingdomName {
  animal("animal"),
  plant("plant");

  const KingdomName(this.value);
  final String value;

  static KingdomName getByValue(index){
    final i = int.parse(index.toString());
    return KingdomName.values.firstWhere((x) => x.index == i);
  }
}

int getKingdomIndex(String kingdomName) {
  switch (kingdomName) {
    case "animal": return 0;
    case "plant": return 1;
  }

  return -1;
}

class PlotObject {
  String title;
  String key;
  String label;
  List<double> values;

  PlotObject(this.title, this.key, this.label, this.values);
}