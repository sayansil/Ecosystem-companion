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

