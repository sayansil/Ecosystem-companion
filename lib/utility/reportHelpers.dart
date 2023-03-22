import 'dart:typed_data';

import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:ecosystem/schema/generated/plot_visualisation_generated.dart';
import 'package:ecosystem/schema/generated/population_ecosystem_generated.dart';
import 'package:ecosystem/schema/generated/report_meta_visualisation_generated.dart';
import 'package:ecosystem/schema/generated/world_ecosystem_generated.dart';
import 'package:ecosystem/utility/simulationHelpers.dart';
import 'package:flat_buffers/flat_buffers.dart' as fb;

void updateData(
    Map<String, Map<String, PlotObject>> plotSeriesData,
    String speciesName,
    String title,
    String key,
    String label,
    double value) {

  final singularPlotObject = PlotObject(title, key, label, [value]);

  if (!plotSeriesData.containsKey(speciesName)) {
    plotSeriesData[speciesName] = {};
  }

  if (!plotSeriesData[speciesName]!.containsKey(key)) {
    plotSeriesData[speciesName]![key] = singularPlotObject;
  } else {
    plotSeriesData[speciesName]![key]!
        .values.add(value);
  }
}

Uint8List getPlotData(List<WorldInstance> dbRows) {
  var builder = fb.Builder(initialSize: 1024);

  Map<String, Map<String, PlotObject>> plotSeriesData = {};

  for (var row in dbRows) {
    final avgWorld = World(row.avgWorld);
    final populationWorld = WorldPopulation(row.populationWorld);

    for (final species in avgWorld.species!) {
      final avgOrganism = species.organism![0];
      final speciesName = avgOrganism.kind!;

      void updateDataForSpecies(title, key, label, value) => updateData(
          plotSeriesData, speciesName, title, key, label, value
      );

      updateDataForSpecies(
          "Age/Fitness On Death Ratio",
          "ageFitnessOnDeathRatio",
          "Value",
          avgOrganism.ageFitnessOnDeathRatio
      );
      updateDataForSpecies(
          "Conceiving Probability",
          "conceivingProbability",
          "Percentage %",
          avgOrganism.conceivingProbability
      );
      updateDataForSpecies(
          "Mating Probability",
          "matingProbability",
          "Percentage %",
          avgOrganism.matingProbability
      );
      updateDataForSpecies(
          "Mating Age Start",
          "matingAgeStart",
          "Years",
          avgOrganism.matingAgeStart
      );
      updateDataForSpecies(
          "Mating Age End",
          "matingAgeEnd",
          "Years",
          avgOrganism.matingAgeEnd
      );
      updateDataForSpecies(
          "Max Age",
          "maxAge",
          "Years",
          avgOrganism.maxAge
      );
      updateDataForSpecies(
          "Mutation Probability",
          "mutationProbability",
          "Percentage %",
          avgOrganism.mutationProbability
      );
      updateDataForSpecies(
          "Offsprings Factor",
          "offspringsFactor",
          "Value",
          avgOrganism.offspringsFactor
      );
      updateDataForSpecies(
          "Height on Speed",
          "heightOnSpeed",
          "Value",
          avgOrganism.heightOnSpeed
      );
      updateDataForSpecies(
          "Height on Stamina",
          "heightOnStamina",
          "Value",
          avgOrganism.heightOnStamina
      );
      updateDataForSpecies(
          "Height on Vitality",
          "heightOnVitality",
          "Value",
          avgOrganism.heightOnVitality
      );
      updateDataForSpecies(
          "Weight on Speed",
          "weightOnSpeed",
          "Value",
          avgOrganism.weightOnSpeed
      );
      updateDataForSpecies(
          "Weight on Stamina",
          "weightOnStamina",
          "Value",
          avgOrganism.weightOnStamina
      );
      updateDataForSpecies(
          "Weight on Vitality",
          "weightOnVitality",
          "Value",
          avgOrganism.weightOnVitality
      );
      updateDataForSpecies(
          "Vitality on Appetite",
          "vitalityOnAppetite",
          "Value",
          avgOrganism.vitalityOnAppetite
      );
      updateDataForSpecies(
          "Vitality on Speed",
          "vitalityOnSpeed",
          "Value",
          avgOrganism.vitalityOnSpeed
      );
      updateDataForSpecies(
          "Stamina on Appetite",
          "staminaOnAppetite",
          "Value",
          avgOrganism.staminaOnAppetite
      );
      updateDataForSpecies(
          "Stamina on Speed",
          "staminaOnSpeed",
          "Value",
          avgOrganism.staminaOnSpeed
      );
      updateDataForSpecies(
          "Theoretical maximum Base Appetite",
          "theoreticalMaximumBaseAppetite",
          "kCal",
          avgOrganism.theoreticalMaximumBaseAppetite
      );
      updateDataForSpecies(
          "Theoretical maximum Base Height",
          "theoreticalMaximumBaseHeight",
          "m",
          avgOrganism.theoreticalMaximumBaseHeight
      );
      updateDataForSpecies(
          "Theoretical maximum Base Speed",
          "theoreticalMaximumBaseSpeed",
          "m/s",
          avgOrganism.theoreticalMaximumBaseSpeed
      );
      updateDataForSpecies(
          "Theoretical maximum Base Stamina",
          "theoreticalMaximumBaseStamina",
          "Value",
          avgOrganism.theoreticalMaximumBaseStamina
      );
      updateDataForSpecies(
          "Theoretical maximum Base Vitality",
          "theoreticalMaximumBaseVitality",
          "Value",
          avgOrganism.theoreticalMaximumBaseVitality
      );
      updateDataForSpecies(
          "Theoretical maximum Base Weight",
          "theoreticalMaximumBaseWeight",
          "kg",
          avgOrganism.theoreticalMaximumBaseWeight
      );
      updateDataForSpecies(
          "Theoretical maximum Height",
          "theoreticalMaximumHeight",
          "m",
          avgOrganism.theoreticalMaximumHeight
      );
      updateDataForSpecies(
          "Theoretical maximum Speed",
          "theoreticalMaximumSpeed",
          "m/s",
          avgOrganism.theoreticalMaximumSpeed
      );
      updateDataForSpecies(
          "Theoretical maximum Weight",
          "theoreticalMaximumWeight",
          "kg",
          avgOrganism.theoreticalMaximumWeight
      );
      updateDataForSpecies(
          "Theoretical maximum Height multiplier",
          "theoreticalMaximumHeightMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumHeightMultiplier
      );
      updateDataForSpecies(
          "Theoretical maximum Speed multiplier",
          "theoreticalMaximumSpeedMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumSpeedMultiplier
      );
      updateDataForSpecies(
          "Theoretical maximum Stamina multiplier",
          "theoreticalMaximumStaminaMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumStaminaMultiplier
      );
      updateDataForSpecies(
          "Theoretical maximum Vitality multiplier",
          "theoreticalMaximumVitalityMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumVitalityMultiplier
      );
      updateDataForSpecies(
          "Theoretical maximum Weight multiplier",
          "theoreticalMaximumWeightyMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumWeightMultiplier
      );
      updateDataForSpecies(
          "Generation",
          "generation",
          "",
          avgOrganism.generation
      );
      updateDataForSpecies(
          "Immunity",
          "immunity",
          "Value",
          avgOrganism.immunity
      );
      updateDataForSpecies(
          "Base Appetite",
          "baseAppetite",
          "kCal",
          avgOrganism.baseAppetite
      );
      updateDataForSpecies(
          "Base Height",
          "baseHeight",
          "m",
          avgOrganism.baseHeight
      );
      updateDataForSpecies(
          "Base Speed",
          "baseSpeed",
          "m/s",
          avgOrganism.baseSpeed
      );
      updateDataForSpecies(
          "Base Stamina",
          "baseStamina",
          "Value",
          avgOrganism.baseStamina
      );
      updateDataForSpecies(
          "Base Vitality",
          "baseVitality",
          "Value",
          avgOrganism.baseVitality
      );
      updateDataForSpecies(
          "Base Weight",
          "baseWeight",
          "kg",
          avgOrganism.baseWeight
      );
      updateDataForSpecies(
          "Height multiplier",
          "heightMultiplier",
          "Value",
          avgOrganism.heightMultiplier
      );
      updateDataForSpecies(
          "Speed multiplier",
          "speedMultiplier",
          "Value",
          avgOrganism.speedMultiplier
      );
      updateDataForSpecies(
          "Stamina multiplier",
          "staminaMultiplier",
          "Value",
          avgOrganism.staminaMultiplier
      );
      updateDataForSpecies(
          "Vitality multiplier",
          "vitalityMultiplier",
          "Value",
          avgOrganism.vitalityMultiplier
      );
      updateDataForSpecies(
          "Weight multiplier",
          "weightMultiplier",
          "Value",
          avgOrganism.weightMultiplier
      );
      updateDataForSpecies(
          "Max Height",
          "maxHeight",
          "m",
          avgOrganism.maxHeight
      );
      updateDataForSpecies(
          "Max Weight",
          "maxWeight",
          "kg",
          avgOrganism.maxWeight
      );
      updateDataForSpecies(
          "Age",
          "age",
          "Years",
          avgOrganism.age
      );
      updateDataForSpecies(
          "Height",
          "height",
          "m",
          avgOrganism.height
      );
      updateDataForSpecies(
          "Weight",
          "weight",
          "kg",
          avgOrganism.weight
      );
      updateDataForSpecies(
          "Static Fitness",
          "staticFitness",
          "Value",
          avgOrganism.staticFitness
      );
      updateDataForSpecies(
          "Max Appetite at its age",
          "maxAppetiteAtAge",
          "kCal",
          avgOrganism.maxAppetiteAtAge
      );
      updateDataForSpecies(
          "Max Speed at its age",
          "maxSpeedAtAge",
          "m/s",
          avgOrganism.maxSpeedAtAge
      );
      updateDataForSpecies(
          "Max Stamina at its age",
          "maxStaminaAtAge",
          "Value",
          avgOrganism.maxStaminaAtAge
      );
      updateDataForSpecies(
          "Max Vitality at its age",
          "maxVitalityAtAge",
          "Value",
          avgOrganism.maxVitalityAtAge
      );
      updateDataForSpecies(
          "Appetite",
          "appetite",
          "kCal",
          avgOrganism.appetite
      );
      updateDataForSpecies(
          "Speed",
          "speed",
          "m/s",
          avgOrganism.speed
      );
      updateDataForSpecies(
          "Stamina",
          "stamina",
          "Value",
          avgOrganism.stamina
      );
      updateDataForSpecies(
          "Vitality",
          "vitality",
          "Value",
          avgOrganism.vitality
      );
      updateDataForSpecies(
          "X Co-ordinate",
          "x",
          "Position",
          avgOrganism.x
      );
      updateDataForSpecies(
          "Y Co-ordinate",
          "y",
          "Position",
          avgOrganism.y
      );
      updateDataForSpecies(
          "Dynamic Fitness",
          "dynamicFitness",
          "Value",
          avgOrganism.dynamicFitness
      );
      updateDataForSpecies(
          "Vision Radius",
          "visionRadius",
          "m",
          avgOrganism.visionRadius
      );
      updateDataForSpecies(
          "Sleep Restore Factor",
          "sleepRestoreFactor",
          "Value",
          avgOrganism.sleepRestoreFactor
      );
    }

    for (final species in populationWorld.speciesPopulation!) {
      final speciesName = species.kind!;

      void updateDataForSpecies(title, key, label, value) => updateData(
          plotSeriesData, speciesName, title, key, label, value
      );

      updateDataForSpecies(
          "Matable Male Population",
          "matableMalePopulation",
          "Population",
          species.matablePopulation!.malePopulation.toDouble()
      );
      updateDataForSpecies(
          "Matable Female Population",
          "matableFemalePopulation",
          "Population",
          species.matablePopulation!.femalePopulation.toDouble()
      );
      updateDataForSpecies(
          "Non-matable Male Population",
          "nonMatableMalePopulation",
          "Population",
          species.nonMatablePopulation!.malePopulation.toDouble()
      );
      updateDataForSpecies(
          "Non-matable Female Population",
          "nonMatableFemalePopulation",
          "Population",
          species.nonMatablePopulation!.femalePopulation.toDouble()
      );
    }
  }

  List<PlotGroupObjectBuilder> plotGroups = [];
  plotSeriesData.forEach((species, speciesPlotData) {
    List<PlotObjectBuilder> plots = [];
    speciesPlotData.forEach((plotKey, plotObject) {
      plots.add(PlotObjectBuilder(
          key: plotKey,
          title: plotObject.title,
          xlabel: "Years",
          ylabel: plotObject.label,
          x: [for (double i = 1; i <= plotObject.values.length; i++) i],
          y: plotObject.values
      ));
    });

    plotGroups.add(PlotGroupObjectBuilder(
        title: species,
        plots: plots
    ));
  });

  final plotBundle =  PlotBundleObjectBuilder(
      plotGroups: plotGroups
  ).finish(builder);

  builder.finish(plotBundle);
  return builder.buffer;
}

MetaObjectBuilder metaObjectBuilder(String title, int createdTs, PlotBundle plotBundle) {
  List<String> subtitles = [];
  plotBundle.plotGroups?.forEach((plotGroup) {
    subtitles.add(plotGroup.title!);
  });

  return MetaObjectBuilder(
      title: title,
      subtiles: subtitles,
      createdTs: createdTs
  );
}

Uint8List getMetaData(
    Uint8List? oldMetaDataBytes,
    String title,
    int createdTs,
    PlotBundle plotBundle) {
  var builder = fb.Builder(initialSize: 1024);
  List<MetaObjectBuilder> data = [];

  if (oldMetaDataBytes != null) {
    final oldMetaData = MetaData(oldMetaDataBytes);
    for (var meta in oldMetaData.data!) {
      data.add(MetaObjectBuilder(
        title: meta.title,
        subtiles: meta.subtiles,
        createdTs: meta.createdTs,
      ));
    }
  }

  data.add(metaObjectBuilder(title, createdTs, plotBundle));

  final metaData = MetaDataObjectBuilder(
    title: "metadata",
    data: data
  ).finish(builder);

  builder.finish(metaData);
  return builder.buffer;
}

