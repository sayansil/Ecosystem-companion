import 'package:ecosystem/constants.dart';
import 'package:ecosystem/schema/generated/world_ecosystem_generated.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:native_simulator/native_simulator.dart';

void testSimulation() async {
  final ecosystemRoot = await getEcosystemRoot();

  nativeCreateGod(true, ecosystemRoot);

  nativeSetInitialOrganisms(KingdomName.animal.index, "deer", 10, 10);
  nativeSetInitialOrganisms(KingdomName.animal.index, "deer", 20, 100);
  nativeSetInitialOrganisms(KingdomName.animal.index, "deer", 30, 50);

  nativeCleanSlate();
  nativeCreateWorld();

  nativeHappyNewYear();
  nativeHappyNewYear();

  final fbList = nativeHappyNewYear();
  var world = new World(fbList);
  print(world.year);
}
