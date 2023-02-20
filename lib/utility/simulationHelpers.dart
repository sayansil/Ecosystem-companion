class SimulationSet {
  String kingdom;
  String species;
  int count;

  SimulationSet(String kingdom, String species, int count)
      : kingdom = kingdom,
        species = species,
        count = count;
}

enum SimulationStatus {
  ready,
  running,
  completed,
  stopped,
}
