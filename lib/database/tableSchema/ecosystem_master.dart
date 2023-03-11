import 'dart:typed_data';

final String dbFileName = "ecosystem_master.db";
final String masterTable = 'ECOSYSTEM_MASTER';

class WorldInstanceFields {
  static final List<String> values = [
    year, avgWorld, populationWorld
  ];

  static final String year = 'YEAR';
  static final String avgWorld = 'AVG_WORLD';
  static final String populationWorld = 'POPULATION_WORLD';
}

class WorldInstance {
  final int year;
  final Uint8List avgWorld;
  final Uint8List populationWorld;

  const WorldInstance({
    required this.year,
    required this.avgWorld,
    required this.populationWorld,
  });

  WorldInstance copy({
    int? year,
    Uint8List? avgWorld,
    Uint8List? populationWorld,
  }) => WorldInstance(
        year: year ?? this.year,
        avgWorld: avgWorld ?? this.avgWorld,
        populationWorld: populationWorld ?? this.populationWorld,
      );

  static WorldInstance fromMap(Map<String, Object?> map) => WorldInstance(
    year: map[WorldInstanceFields.year] as int,
    avgWorld: map[WorldInstanceFields.avgWorld] as Uint8List,
    populationWorld: map[WorldInstanceFields.populationWorld] as Uint8List,
  );

  Map<String, Object?> toMap() => {
    WorldInstanceFields.year: year,
    WorldInstanceFields.avgWorld: avgWorld,
    WorldInstanceFields.populationWorld: populationWorld,
  };
}