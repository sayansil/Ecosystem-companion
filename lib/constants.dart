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
const colorAccentLight = Color(0xcce8dff8);
const colorAccent = Color(0xffa57afa);
const colorAnimalAccent = Color(0xffd8e5ee);
const colorPlantAccent = Color(0xffd4efcf);

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
const maskPadding = 30.0;

// * Global parameters

const dataDir = "data";
final templateDir = join("data", "json");
const ecosystemDir = "Ecosystem";
const reportDir = "Reports";
const metaDataFileName = ".metadata";

final assetSpeciesTemplatePath = join("assets", "json", "simulationTemplates");

const allSpeciesIdentifier = "all";
const defaultAttributeIdentifier = "population";

enum DrawerItem { home, config, history, about, contribute, organism }

// * Asset Paths

const assetLoading = "assets/json/animation/loading.json";
const assetEmpty = "assets/json/animation/empty.json";
const assetHappyDog = "assets/json/animation/dog-happy.json";

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

const downloadSpeciesMessage = "This download might take a minute or two...";
const downloadSpeciesAccept = "Yes";
const downloadSpeciesReject = "No";

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
const snackBarCannotDownloadText = "Could not download. Please check your internet connection.";

const permissionStorageNotGranted = "Could not access device storage :(";
const permissionStorageGrantRequest = "Please grant storage permission to proceed";

const noSpeciesFound = "No species found in that Kingdom. Please create one.";
const invalidReportPath = "Report not found";
const simulationKingdomInputText = "Select a Kingdom";
const simulationKindInputText = "Select a Species";

const addSampleSpeciesHeader = "Add sample species…";

const navTitleHome = "Home";
const navTitleSpecies = "New species";
const navTitleHistory = "History";
const navTitleAbout = "About";
const navTitleContribute = "Contribute";

const screenTitleHome = "Home";
const screenTitleSpecies = "Add species";
const screenTitleHistory = "History";
const screenTitleAbout = "About";

const footerTitleText = "Made with ❤️";
const stayTunedText = "Keep an eye on this space...";
const aboutText = "In this project, the user plays the role of the God. This "
    "app helps the user mimic a real-world ecosystem where he can introduce "
    "new organisms with custom characteristics and also bring changes to the "
    "ecosystem and then observe their behavior and reaction to those changes. "
    "Thus the user can be looked upon as The God of the ecosystem who has the "
    "power to bring any change with which he can simulate the problems "
    "happening worldwide and gain valuable insights on how the organisms try "
    "to adapt to the change to ensure their survival. Studying the overall "
    "behavior of the ecosystem will provide us with a wealth of knowledge and "
    "be far better prepared for how we should be equipped to handle the "
    "future.";