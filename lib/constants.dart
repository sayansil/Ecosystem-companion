import 'package:flutter/material.dart';
import 'package:path/path.dart';

// * Global colors for application

const colorPrimary = Color(0xFF181818);
const colorPrimaryLight = Color(0xFF282828);
const colorSecondary = Color(0xFF696969);
const colorSecondaryLight = Color(0x80B9B9B9);
const colorBackground = Color(0xFFF0F0F0);
const colorTextDark = Color(0x80181818);
const colorTextLight = Color(0x80FFFFFF);

// * Global spacing

const defaultPadding = 30.0;
const defaultSmallPadding = 20.0;

// * Global parameters

const dataDir = "data";
final templateDir = join("data", "json");
const ecosystemDir = "Ecosystem";

final assetSpeciesTemplatePath = join("assets", "json", "simulationTemplates");

enum DrawerItem { home, config, settings, about, contribute, organism }

const completeSpeciesList = {
  "animal": ["lion", "deer"],
  "plant": ["bamboo"]
};

enum KingdomName {
  animal("animal"),
  plant("plant");

  const KingdomName(this.value);
  final String value;
}

// * String constants

const githubUrl = "https://github.com/sayansil/Ecosystem-companion";

const simulateBtn = "SIMULATE 🐗";
const addSpeciesBtn = "ADD";
const saveConfigBtn = "SAVE";

const stopSimulationTitle = "Exit Simulation? 🕊️";
const stopSimulationMessage = "All data from the current simulation will be lost...";
const stopSimulationAccept = "Yes";
const stopSimulationReject = "No";

const addConfigsTitle = "Configs not set 😔";
const addConfigsMessage = "Would you like to set them now?";
const addConfigsAccept = "Yes";
const addConfigsReject = "No";

const simulateStartBtn = "Start";
const simulateStopBtn = "Stop";

const configLocalDbPathText = "Local database directory path";
const configLocalReportDirText = "Simulation report directory path";

const speciesSelectBaseJsonPath = "Base Json config (optional)";
const speciesSelectModifyJsonPath = "Modify Json config (optional)";

const configKingdomInputText = "Select a Kingdom";
const configKindInputText = "Species name";

const snackBarAddedSpeciesText = "Species added successfully";

const permissionStorageNotGranted = "Could not access device storage :(";
const permissionStorageGrantRequest = "Please grant storage permission to proceed";