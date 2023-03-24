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
      final kingdomName = avgOrganism.kingdom.value.toString();

      void updateDataForSpecies(title, key, label, value) => updateData(
          plotSeriesData, "${kingdomName}_$speciesName", title, key, label, value
      );

      updateDataForSpecies(
          "Age/Fitness On Death Ratio",
          "ageFitnessOnDeathRatio",
          "Value",
          avgOrganism.ageFitnessOnDeathRatio.toDouble()
      );
      updateDataForSpecies(
          "Conceiving Probability",
          "conceivingProbability",
          "Percentage %",
          avgOrganism.conceivingProbability.toDouble()
      );
      updateDataForSpecies(
          "Mating Probability",
          "matingProbability",
          "Percentage %",
          avgOrganism.matingProbability.toDouble()
      );
      updateDataForSpecies(
          "Mating Age Start",
          "matingAgeStart",
          "Years",
          avgOrganism.matingAgeStart.toDouble()
      );
      updateDataForSpecies(
          "Mating Age End",
          "matingAgeEnd",
          "Years",
          avgOrganism.matingAgeEnd.toDouble()
      );
      updateDataForSpecies(
          "Max Age",
          "maxAge",
          "Years",
          avgOrganism.maxAge.toDouble()
      );
      updateDataForSpecies(
          "Mutation Probability",
          "mutationProbability",
          "Percentage %",
          avgOrganism.mutationProbability.toDouble()
      );
      updateDataForSpecies(
          "Offsprings Factor",
          "offspringsFactor",
          "Value",
          avgOrganism.offspringsFactor.toDouble()
      );
      updateDataForSpecies(
          "Height on Speed",
          "heightOnSpeed",
          "Value",
          avgOrganism.heightOnSpeed.toDouble()
      );
      updateDataForSpecies(
          "Height on Stamina",
          "heightOnStamina",
          "Value",
          avgOrganism.heightOnStamina.toDouble()
      );
      updateDataForSpecies(
          "Height on Vitality",
          "heightOnVitality",
          "Value",
          avgOrganism.heightOnVitality.toDouble()
      );
      updateDataForSpecies(
          "Weight on Speed",
          "weightOnSpeed",
          "Value",
          avgOrganism.weightOnSpeed.toDouble()
      );
      updateDataForSpecies(
          "Weight on Stamina",
          "weightOnStamina",
          "Value",
          avgOrganism.weightOnStamina.toDouble()
      );
      updateDataForSpecies(
          "Weight on Vitality",
          "weightOnVitality",
          "Value",
          avgOrganism.weightOnVitality.toDouble()
      );
      updateDataForSpecies(
          "Vitality on Appetite",
          "vitalityOnAppetite",
          "Value",
          avgOrganism.vitalityOnAppetite.toDouble()
      );
      updateDataForSpecies(
          "Vitality on Speed",
          "vitalityOnSpeed",
          "Value",
          avgOrganism.vitalityOnSpeed.toDouble()
      );
      updateDataForSpecies(
          "Stamina on Appetite",
          "staminaOnAppetite",
          "Value",
          avgOrganism.staminaOnAppetite.toDouble()
      );
      updateDataForSpecies(
          "Stamina on Speed",
          "staminaOnSpeed",
          "Value",
          avgOrganism.staminaOnSpeed.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Base Appetite",
          "theoreticalMaximumBaseAppetite",
          "kCal",
          avgOrganism.theoreticalMaximumBaseAppetite.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Base Height",
          "theoreticalMaximumBaseHeight",
          "m",
          avgOrganism.theoreticalMaximumBaseHeight.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Base Speed",
          "theoreticalMaximumBaseSpeed",
          "m/s",
          avgOrganism.theoreticalMaximumBaseSpeed.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Base Stamina",
          "theoreticalMaximumBaseStamina",
          "Value",
          avgOrganism.theoreticalMaximumBaseStamina.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Base Vitality",
          "theoreticalMaximumBaseVitality",
          "Value",
          avgOrganism.theoreticalMaximumBaseVitality.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Base Weight",
          "theoreticalMaximumBaseWeight",
          "kg",
          avgOrganism.theoreticalMaximumBaseWeight.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Height",
          "theoreticalMaximumHeight",
          "m",
          avgOrganism.theoreticalMaximumHeight.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Speed",
          "theoreticalMaximumSpeed",
          "m/s",
          avgOrganism.theoreticalMaximumSpeed.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Weight",
          "theoreticalMaximumWeight",
          "kg",
          avgOrganism.theoreticalMaximumWeight.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Height multiplier",
          "theoreticalMaximumHeightMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumHeightMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Speed multiplier",
          "theoreticalMaximumSpeedMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumSpeedMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Stamina multiplier",
          "theoreticalMaximumStaminaMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumStaminaMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Vitality multiplier",
          "theoreticalMaximumVitalityMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumVitalityMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Theoretical maximum Weight multiplier",
          "theoreticalMaximumWeightyMultiplier",
          "Value",
          avgOrganism.theoreticalMaximumWeightMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Generation",
          "generation",
          "",
          avgOrganism.generation.toDouble()
      );
      updateDataForSpecies(
          "Immunity",
          "immunity",
          "Value",
          avgOrganism.immunity.toDouble()
      );
      updateDataForSpecies(
          "Base Appetite",
          "baseAppetite",
          "kCal",
          avgOrganism.baseAppetite.toDouble()
      );
      updateDataForSpecies(
          "Base Height",
          "baseHeight",
          "m",
          avgOrganism.baseHeight.toDouble()
      );
      updateDataForSpecies(
          "Base Speed",
          "baseSpeed",
          "m/s",
          avgOrganism.baseSpeed.toDouble()
      );
      updateDataForSpecies(
          "Base Stamina",
          "baseStamina",
          "Value",
          avgOrganism.baseStamina.toDouble()
      );
      updateDataForSpecies(
          "Base Vitality",
          "baseVitality",
          "Value",
          avgOrganism.baseVitality.toDouble()
      );
      updateDataForSpecies(
          "Base Weight",
          "baseWeight",
          "kg",
          avgOrganism.baseWeight.toDouble()
      );
      updateDataForSpecies(
          "Height multiplier",
          "heightMultiplier",
          "Value",
          avgOrganism.heightMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Speed multiplier",
          "speedMultiplier",
          "Value",
          avgOrganism.speedMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Stamina multiplier",
          "staminaMultiplier",
          "Value",
          avgOrganism.staminaMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Vitality multiplier",
          "vitalityMultiplier",
          "Value",
          avgOrganism.vitalityMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Weight multiplier",
          "weightMultiplier",
          "Value",
          avgOrganism.weightMultiplier.toDouble()
      );
      updateDataForSpecies(
          "Max Height",
          "maxHeight",
          "m",
          avgOrganism.maxHeight.toDouble()
      );
      updateDataForSpecies(
          "Max Weight",
          "maxWeight",
          "kg",
          avgOrganism.maxWeight.toDouble()
      );
      updateDataForSpecies(
          "Age",
          "age",
          "Years",
          avgOrganism.age.toDouble()
      );
      updateDataForSpecies(
          "Height",
          "height",
          "m",
          avgOrganism.height.toDouble()
      );
      updateDataForSpecies(
          "Weight",
          "weight",
          "kg",
          avgOrganism.weight.toDouble()
      );
      updateDataForSpecies(
          "Static Fitness",
          "staticFitness",
          "Value",
          avgOrganism.staticFitness.toDouble()
      );
      updateDataForSpecies(
          "Max Appetite at its age",
          "maxAppetiteAtAge",
          "kCal",
          avgOrganism.maxAppetiteAtAge.toDouble()
      );
      updateDataForSpecies(
          "Max Speed at its age",
          "maxSpeedAtAge",
          "m/s",
          avgOrganism.maxSpeedAtAge.toDouble()
      );
      updateDataForSpecies(
          "Max Stamina at its age",
          "maxStaminaAtAge",
          "Value",
          avgOrganism.maxStaminaAtAge.toDouble()
      );
      updateDataForSpecies(
          "Max Vitality at its age",
          "maxVitalityAtAge",
          "Value",
          avgOrganism.maxVitalityAtAge.toDouble()
      );
      updateDataForSpecies(
          "Appetite",
          "appetite",
          "kCal",
          avgOrganism.appetite.toDouble()
      );
      updateDataForSpecies(
          "Speed",
          "speed",
          "m/s",
          avgOrganism.speed.toDouble()
      );
      updateDataForSpecies(
          "Stamina",
          "stamina",
          "Value",
          avgOrganism.stamina.toDouble()
      );
      updateDataForSpecies(
          "Vitality",
          "vitality",
          "Value",
          avgOrganism.vitality.toDouble()
      );
      updateDataForSpecies(
          "X Co-ordinate",
          "x",
          "Position",
          avgOrganism.x.toDouble()
      );
      updateDataForSpecies(
          "Y Co-ordinate",
          "y",
          "Position",
          avgOrganism.y.toDouble()
      );
      updateDataForSpecies(
          "Dynamic Fitness",
          "dynamicFitness",
          "Value",
          avgOrganism.dynamicFitness.toDouble()
      );
      updateDataForSpecies(
          "Vision Radius",
          "visionRadius",
          "m",
          avgOrganism.visionRadius.toDouble()
      );
      updateDataForSpecies(
          "Sleep Restore Factor",
          "sleepRestoreFactor",
          "Value",
          avgOrganism.sleepRestoreFactor.toDouble()
      );
    }

    for (final species in populationWorld.speciesPopulation!) {
      final speciesName = species.kind!;
      final kingdomName = species.kingdom;

      void updateDataForSpecies(title, key, label, value) => updateData(
          plotSeriesData, "${kingdomName}_$speciesName", title, key, label, value
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

    final kingdom = species.substring(0, species.indexOf("_"));
    final kind = species.substring(species.indexOf("_") + 1);

    plotGroups.add(PlotGroupObjectBuilder(
        name: kind,
        type: kingdom,
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
    subtitles.add(plotGroup.name!);
  });

  return MetaObjectBuilder(
      title: title,
      subtiles: subtitles,
      createdTs: createdTs
  );
}

Uint8List addMetaData(
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

Uint8List removeMetaData(Uint8List? oldMetaDataBytes, String title) {
  var builder = fb.Builder(initialSize: 1024);
  List<MetaObjectBuilder> data = [];

  if (oldMetaDataBytes != null) {
    final oldMetaData = MetaData(oldMetaDataBytes);
    for (var meta in oldMetaData.data!) {
      if (meta.title != title) {
        data.add(MetaObjectBuilder(
          title: meta.title,
          subtiles: meta.subtiles,
          createdTs: meta.createdTs,
        ));
      }
    }
  }

  final metaData = MetaDataObjectBuilder(
      title: "metadata",
      data: data
  ).finish(builder);

  builder.finish(metaData);
  return builder.buffer;
}

