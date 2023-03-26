import 'package:flutter/material.dart';
import 'package:path/path.dart';

// * Global colors for application

const colorPrimary = Color(0xFF181818);
const colorPrimaryLight = Color(0xFF282828);
const colorSecondary = Color(0xFF696969);
const colorTertiary = Color(0xFFA2A2A2);
const colorSecondaryLight = Color(0x80B9B9B9);
const colorTertiaryLight = Color(0xD7A2A2A2);
const colorBackground = Color(0xFFF0F0F0);
const colorBackgroundSeeThrough = Color(0xA6F0F0F0);
const colorTextDark = Color(0x80181818);
const colorTextLight = Color(0x80FFFFFF);

const plotLineColors = [
  Colors.deepPurple,
  Colors.pink,
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.amber,
  Colors.cyan,
];

// * Global spacing

const defaultPadding = 30.0;
const defaultSmallPadding = 20.0;

// * Global parameters

const dataDir = "data";
final templateDir = join("data", "json");
const ecosystemDir = "Ecosystem";
const reportDir = "Reports";
const metaDataFileName = ".metadata";

final assetSpeciesTemplatePath = join("assets", "json", "simulationTemplates");

enum DrawerItem { home, config, history, about, contribute, organism }

// * Asset Paths

const assetLoading = "assets/json/animation/loading.json";
const assetEmpty = "assets/json/animation/empty.json";

// * String constants

const githubUrl = "https://github.com/sayansil/Ecosystem-companion";
const darkStar1997Url = "https://github.com/DarkStar1997";
const sincereSantaUrl = "https://github.com/sayansil";

const simulateBtn = "SIMULATE 🐗";
const addSpeciesBtn = "ADD";
const saveConfigBtn = "SAVE";

const stopSimulationTitle = "Exit Simulation? 🕊️";
const stopSimulationMessage = "All unsaved data from the current simulation will be lost...";
const stopSimulationAccept = "Yes";
const stopSimulationReject = "No";

const confirmDeleteTitle = "Deleting simulation report 😔";
const confirmDeleteMessage = "Are you sure you want to delete this report?";
const confirmDeleteAccept = "Yes";
const confirmDeleteReject = "No";

const simulateStartBtn = "Start";
const simulateStopBtn = "Stop";
const simulateViewBtn = "View";

const configLocalDbPathText = "Local database directory path";
const configLocalReportDirText = "Simulation report directory path";

const speciesSelectBaseJsonPath = "Base Json config (optional)";
const speciesSelectModifyJsonPath = "Modify Json config (optional)";

const configKingdomInputText = "Select a Kingdom";
const configKindInputText = "Species name";

const snackBarAddedSpeciesText = "Species added successfully";
const snackBarSavedReportText = "Report saved";

const permissionStorageNotGranted = "Could not access device storage :(";
const permissionStorageGrantRequest = "Please grant storage permission to proceed";

const noSpeciesFound = "No species found in that Kingdom. Please create one.";
const invalidReportPath = "Report not found";
const simulationKingdomInputText = "Select a Kingdom";
const simulationKindInputText = "Select a Species";

const footerTitleText = "Made with ❤️";