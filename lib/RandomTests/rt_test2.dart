import 'dart:io';

import 'package:path/path.dart';
import 'package:ecosystem/constants.dart';
import 'package:ecosystem/database/database_manager.dart';
import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:ecosystem/schema/generated/world_ecosystem_generated.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:native_simulator/native_simulator.dart';


Future<void> testSimulation() async {
  final ecosystemRoot = await getEcosystemRoot();

  NativeSimulator simulator = NativeSimulator(ecosystemRoot);

  simulator.createInitialOrganisms(KingdomName.animal.index, "deer", 10, 500);
  simulator.createInitialOrganisms(KingdomName.animal.index, "deer", 20, 100);
  simulator.createInitialOrganisms(KingdomName.animal.index, "deer", 30, 500);

  simulator.prepareWorld();

  for( var i = 0 ; i < 100; i++ ) {
    final fbList = simulator.simulateOneYear();
    final bufferSize = fbList.length;
    int population = 0;

    var world = new World(fbList);
    if (world.species != null) {
      world.species!.forEach((species) {
        population += species.organism!.length;
      });
    }

    print("Year: ${world.year} - Buffer Size: $bufferSize - Population: $population");
  }

  simulator.cleanup();
}

Future<void> testSimulationDb() async {
  final dbInstance = MasterDatabase.instance;
  List<WorldInstance> rows = await dbInstance.readAllRows();


  final world = World(rows.last.avgWorld);

  print(rows.length.toString() + " number of rows");
  print(world.year.toString() + " is the last year.");
  print(world.species!.length.toString() + " number of species");

  await dbInstance.close();
}

Future<void> deleteDB() async {
  final ecosystemRoot = await getEcosystemRoot();

  try {
    final dbFile = File(join(ecosystemRoot, dataDir, dbFileName));
    await dbFile.delete();
    print("DB deleted successfully");
  } catch (e) {
    print("Error in deleteDB: " + e.toString());
  }
}


Future<void> deleteSpecies(String kingdom, String kind) async {
  final ecosystemRoot = await getEcosystemRoot();

  try {
    final speciesDir = Directory(join(ecosystemRoot, templateDir, kingdom, kind));
    speciesDir.deleteSync(recursive: true);
    print("Species config deleted successfully");
  } catch (e) {
    print("Error in deleteSpecies: " + e.toString());
  }
}
