import 'package:flutter/material.dart';
import 'package:montoring_app/models/Contacts.dart';
import 'package:montoring_app/models/EducationStatistics.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/IrrigationSystem.dart';
import 'package:montoring_app/models/LiveStock.dart';
import 'package:montoring_app/models/MyBuilding.dart';
import 'package:montoring_app/models/MyCrafts.dart';
import 'package:montoring_app/models/MyHerbs.dart';
import 'package:montoring_app/models/MyNeeds.dart';
import 'package:montoring_app/models/MyRoads.dart';
import 'package:montoring_app/models/MyTrees.dart';
import 'package:montoring_app/models/Population.dart';

class SurveyDataProvider extends ChangeNotifier {
  Infrastructure _infrastructure = Infrastructure.initial();

  Infrastructure get infrastructure => _infrastructure;

  List<String> imagePaths = [];

  int totalMen = 0;
  int totalWomen = 0;
  int totalOlderBoys = 0;
  int totalOlderGirls = 0;
  int totalYoungerBoys = 0;
  int totalYoungerGirls = 0;

  int totalFamilies = 0;
  int totalHouseholds = 0;

  int totalPopulation = 0;

  int totalMenDisplaced = 0;
  int totalWomenDisplaced = 0;
  int totalBoysDisplaced = 0;
  int totalGirlsDisplaced = 0;

  // remove this
  int totalLivestockAnimals = 0;
  String village = "";
  String valley = "";
  String commune = "";
  String province = "";
  List<Contacts> contacts = [];
  List<Myherbs> herbs = [];
  List<MyCrafts> crafts = [];
  List<IrrigationSystem> irrigationSystems = [];
  List<Livestock> livestock = [];
  List<MyBuilding> buildings = [];
  List<MyNeeds> needs = [];
  List<IrrigationSystem> irrigations = [];
  List<MyTrees> trees = [];
  List<MyRoads> roads = [];

  int numberOfLiterateMen = 0;
  int numberOfLiterateWomen = 0;
  int numberOfPostGraduateMen = 0;
  int numberOfPostGraduateWomen = 0;
  int numberOfBaccalaureateMen = 0;
  int numberOfBaccalaureateWomen = 0;
  int numberOfMiddleSchoolGraduateMen = 0;
  int numberOfMiddleSchoolGraduateWomen = 0;
  int numberOfPrimarySchoolGraduateMen = 0;
  int numberOfPrimarySchoolGraduateWomen = 0;
  int numberOfIlliterateMen = 0;
  int numberOfIlliterateWomen = 0;

  int totalHomes = 0;
  int totalHomesUnstable = 0;
  int totalHomesIntact = 0;

  bool hasRunningWater = false;
  bool hasWell = false;
  bool hasSinks = false;
  bool usesNaturalSources = false;
  bool isWaterAvailable = true;
  bool isElectricityAvailable = true;
  String notAvailableReason = "";
  String electricityNotAvailableReason = "";
  bool hasInternet = false;
  bool hasSatellites = false;
  bool hasMobileNetworkTowers = false;
  bool hasSchool = true;

  double irrigatedLands = 0;
  double barrenLands = 0;
  double landsize = 0;

  bool subsistence = false;
  bool financial = false;
  bool belongsToubkal = false;

  String roadStatus = "Stable";
  String roadName = "";
  String roadVehicleType = "N/A";

  String waterStatus = "Available";
  String electricityStatus = "Available";
  String selectedStatus = "Unknown";

  void addImagePath(String path) {
    imagePaths.add(path);
    notifyListeners();
  }

  Population getPopulation() {
    return Population(
        totalMenDisplaced: totalMenDisplaced,
        totalWomenDisplaced: totalWomenDisplaced,
        totalBoysDisplaced: totalBoysDisplaced,
        totalGirlsDisplaced: totalGirlsDisplaced,
        totalPopulation: totalPopulation,
        totalMen: totalMen,
        totalWomen: totalWomen,
        totalOlderBoys: totalOlderBoys,
        totalOlderGirls: totalOlderGirls,
        totalYoungerBoys: totalYoungerBoys,
        totalYoungerGirls: totalYoungerGirls,
        totalFamilies: totalFamilies,
        totalHouseholds: totalHouseholds);
  }

  Infrastructure getInfrastructure() {
    return Infrastructure(
      totalHomes: totalHomes,
      totalHomesUnstable: totalHomesUnstable,
      totalHomesIntact: totalHomesIntact,
      roadList: roads,
      hasRunningWater: hasRunningWater,
      hasWell: hasWell,
      hasSinks: hasSinks,
      usesNaturalSources: usesNaturalSources,
      isWaterAvailable: isWaterAvailable,
      notAvailableReason: notAvailableReason,
      electricityNotAvailableReason: electricityNotAvailableReason,
      hasInternet: hasInternet,
      hasSatellites: hasSatellites,
      hasMobileNetworkTowers: hasMobileNetworkTowers,
      buildings: buildings,
      isElectricityAvailable: isElectricityAvailable,
    );
  }

  EducationStatistics getEducationStatistics() {
    return EducationStatistics(
        numberOfLiterateMen: numberOfLiterateMen,
        numberOfLiterateWomen: numberOfLiterateWomen,
        numberOfPostGraduateMen: numberOfPostGraduateMen,
        numberOfPostGraduateWomen: numberOfPostGraduateWomen,
        numberOfBaccalaureateMen: numberOfBaccalaureateMen,
        numberOfBaccalaureateWomen: numberOfBaccalaureateWomen,
        numberOfMiddleSchoolGraduateMen: numberOfMiddleSchoolGraduateMen,
        numberOfMiddleSchoolGraduateWomen: numberOfMiddleSchoolGraduateWomen,
        numberOfPrimarySchoolGraduateMen: numberOfPrimarySchoolGraduateMen,
        numberOfPrimarySchoolGraduateWomen: numberOfPrimarySchoolGraduateWomen,
        numberOfIlliterateMen: numberOfIlliterateMen,
        numberOfIlliterateWomen: numberOfIlliterateWomen,
        hasSchool: hasSchool);
  }

  void updateVillage(String newValue) {
    village = newValue;
    notifyListeners();
  }

  void updateValley(String newValue) {
    valley = newValue;
    notifyListeners();
  }

  void updateCommune(String newValue) {
    commune = newValue;
    notifyListeners();
  }

  void updateProvince(String newValue) {
    province = newValue;
    notifyListeners();
  }

  void updateIrrigatedLands(double newValue) {
    irrigatedLands = newValue;
    notifyListeners();
  }

  void updateBarrenLands(double newValue) {
    barrenLands = newValue;
    notifyListeners();
  }

  void updateLandSize(double newValue) {
    landsize = newValue;
    notifyListeners();
  }

  void updateSubsistence(bool newValue) {
    subsistence = newValue;
    notifyListeners();
  }

  void updateFinancial(bool newValue) {
    financial = newValue;
    notifyListeners();
  }

  void updateBelongsToubkal(bool newValue) {
    belongsToubkal = newValue;
    notifyListeners();
  }

  void updateHasRunningWater(bool newValue) {
    hasRunningWater = newValue;
    notifyListeners();
  }

  void updateHasSchool(bool newValue) {
    hasSchool = newValue;
    notifyListeners();
  }

  void updateHasWell(bool newValue) {
    hasWell = newValue;
    notifyListeners();
  }

  void updateHasSinks(bool newValue) {
    hasSinks = newValue;
    notifyListeners();
  }

  void updateUsesNaturalSources(bool newValue) {
    usesNaturalSources = newValue;
    notifyListeners();
  }

  void updateIsWaterAvailable(bool newValue) {
    isWaterAvailable = newValue;
    notifyListeners();
  }

  void updateIsElectricityAvailable(bool newValue) {
    isWaterAvailable = newValue;
    notifyListeners();
  }

  void updateNotAvailableReason(String newValue) {
    notAvailableReason = newValue;
    notifyListeners();
  }

  void updateElectricityNotAvailableReason(String newValue) {
    electricityNotAvailableReason = newValue;
    notifyListeners();
  }

  void updateHasInternet(bool newValue) {
    hasInternet = newValue;
    notifyListeners();
  }

  void updateHasSatellites(bool newValue) {
    hasSatellites = newValue;
    notifyListeners();
  }

  void updateHasMobileNetworkTowers(bool newValue) {
    hasMobileNetworkTowers = newValue;
    notifyListeners();
  }

  void updateContancts(List<Contacts> newValue) {
    contacts = newValue;
    notifyListeners();
  }

  void updateHerbs(List<Myherbs> newValue) {
    herbs = newValue;
    notifyListeners();
  }

  void updateCrafts(List<MyCrafts> newValue) {
    crafts = newValue;
    notifyListeners();
  }

  void updateLivestock(List<Livestock> newValue) {
    livestock = newValue;
    notifyListeners();
  }

  void updateIrrigationSystems(List<IrrigationSystem> newValue) {
    irrigations = newValue;
    notifyListeners();
  }

  void updateBuildings(List<MyBuilding> newValue) {
    buildings = newValue;
    notifyListeners();
  }

  void updateRoads(List<MyRoads> newValue) {
    roads = newValue;
    notifyListeners();
  }

  void updateTrees(List<MyTrees> newValue) {
    trees = newValue;
    notifyListeners();
  }

  void updateNeeds(List<MyNeeds> newValue) {
    needs = newValue;
    notifyListeners();
  }

  void updateTotalWomen(int newValue) {
    totalWomen = newValue;
    notifyListeners();
  }

  void updateTotalPopulation(int newValue) {
    totalPopulation = newValue;
    notifyListeners();
  }

  void updateTotalFamilies(int newValue) {
    totalFamilies = newValue;
    notifyListeners();
  }

  void updateTotalHouseHolds(int newValue) {
    totalHouseholds = newValue;
    notifyListeners();
  }

  void updateTotalMen(int newValue) {
    totalMen = newValue;
    notifyListeners();
  }

  void updateTotalYoungerBoys(int newValue) {
    totalYoungerBoys = newValue;
    notifyListeners();
  }

  void updateTotalYoungerGirls(int newValue) {
    totalYoungerGirls = newValue;
    notifyListeners();
  }

  void updateTotalOlderBoys(int newValue) {
    totalOlderBoys = newValue;
    notifyListeners();
  }

  void updateTotalOlderGirls(int newValue) {
    totalOlderGirls = newValue;
    notifyListeners();
  }

  void updateTotalMenDisplaced(int newValue) {
    totalMenDisplaced = newValue;
    notifyListeners();
  }

  void updateTotalWomenDisplaced(int newValue) {
    totalWomenDisplaced = newValue;
    notifyListeners();
  }

  void updateTotalBoysDisplaced(int newValue) {
    totalBoysDisplaced = newValue;
    notifyListeners();
  }

  void updateTotalGirlsDisplaced(int newValue) {
    totalGirlsDisplaced = newValue;
    notifyListeners();
  }

  void updateTotalLivestockAnimals(int newValue) {
    totalLivestockAnimals = newValue;
    notifyListeners();
  }

  void updatetotalHomes(int newValue) {
    totalHomes = newValue;
    notifyListeners();
  }

  void updateTotalHomesUnstable(int newValue) {
    totalHomesUnstable = newValue;
    notifyListeners();
  }

  void updateTotalHomesIntact(int newValue) {
    totalHomesIntact = newValue;
    notifyListeners();
  }

  void updateNumberOfLiterateMen(int newValue) {
    numberOfLiterateMen = newValue;
    notifyListeners();
  }

  void updateNumberOfLiterateWomen(int newValue) {
    numberOfLiterateWomen = newValue;
    notifyListeners();
  }

  void updateNumberOfPostGraduateMen(int newValue) {
    numberOfPostGraduateMen = newValue;
    notifyListeners();
  }

  void updateNumberOfPostGraduateWomen(int newValue) {
    numberOfPostGraduateWomen = newValue;
    notifyListeners();
  }

  void updateNumberOfBaccalaureateMen(int newValue) {
    numberOfBaccalaureateMen = newValue;
    notifyListeners();
  }

  void updateNumberOfBaccalaureateWomen(int newValue) {
    numberOfBaccalaureateWomen = newValue;
    notifyListeners();
  }

  void updateNumberOfMiddleSchoolGraduateMen(int newValue) {
    numberOfMiddleSchoolGraduateMen = newValue;
    notifyListeners();
  }

  void updateNumberOfMiddleSchoolGraduateWomen(int newValue) {
    numberOfMiddleSchoolGraduateWomen = newValue;
    notifyListeners();
  }

  void updateNumberOfPrimarySchoolGraduateMen(int newValue) {
    numberOfPrimarySchoolGraduateMen = newValue;
    notifyListeners();
  }

  void updateNumberOfPrimarySchoolGraduateWomen(int newValue) {
    numberOfPrimarySchoolGraduateWomen = newValue;
    notifyListeners();
  }

  void updateNumberOfIlliterateMen(int newValue) {
    numberOfIlliterateMen = newValue;
    notifyListeners();
  }

  void updateNumberOfIlliterateWomen(int newValue) {
    numberOfIlliterateWomen = newValue;
    notifyListeners();
  }

  void updateRoadStatus(String newValue) {
    roadStatus = newValue;
    notifyListeners();
  }

  void updateRoadName(String newValue) {
    roadName = newValue;
    notifyListeners();
  }

  void updateRoadVehicleType(String newValue) {
    roadVehicleType = newValue;
    notifyListeners();
  }

  void updateWaterStatus(String newValue) {
    waterStatus = newValue;
    notifyListeners();
  }

  void updateElectricityStatus(String newValue) {
    electricityStatus = newValue;
    notifyListeners();
  }

  void updateSelectedStatus(String newValue) {
    selectedStatus = newValue;
    notifyListeners();
  }

  void resetData() {
    // Reset population data
    totalMen = 0;
    totalWomen = 0;
    totalOlderBoys = 0;
    totalOlderGirls = 0;
    totalYoungerBoys = 0;
    totalYoungerGirls = 0;
    totalFamilies = 0;
    totalPopulation = 0;
    totalMenDisplaced = 0;
    totalWomenDisplaced = 0;
    totalBoysDisplaced = 0;
    totalGirlsDisplaced = 0;

    // Reset contacts
    contacts.clear();

    // Reset infrastructure data
    totalHomes = 0;
    totalHomesUnstable = 0;
    totalHomesIntact = 0;

    roadStatus = "Stable";
    roadName = "";
    roadVehicleType = "N/A";
    waterStatus = "Available";
    electricityStatus = "Available";
    selectedStatus = "Unknown";

    // Reset other data properties
    imagePaths.clear();
    totalLivestockAnimals = 0;
    village = "";
    valley = "";
    commune = "";
    province = "";
    herbs.clear();
    crafts.clear();
    irrigationSystems.clear();
    livestock.clear();
    buildings.clear();
    needs.clear();
    irrigations.clear();
    trees.clear();
    roads.clear();
    numberOfLiterateMen = 0;
    numberOfLiterateWomen = 0;
    numberOfPostGraduateMen = 0;
    numberOfPostGraduateWomen = 0;
    numberOfBaccalaureateMen = 0;
    numberOfBaccalaureateWomen = 0;
    numberOfMiddleSchoolGraduateMen = 0;
    numberOfMiddleSchoolGraduateWomen = 0;
    numberOfPrimarySchoolGraduateMen = 0;
    numberOfPrimarySchoolGraduateWomen = 0;
    numberOfIlliterateMen = 0;
    numberOfIlliterateWomen = 0;
    landsize = 0;
    irrigatedLands = 0;
    barrenLands = 0;
    subsistence = false;
    financial = false;
    belongsToubkal = false;
    hasRunningWater = false;
    hasWell = false;
    hasSinks = false;
    usesNaturalSources = false;
    isWaterAvailable = true;
    isElectricityAvailable = true;
    notAvailableReason = "";
    electricityNotAvailableReason = "";
    hasInternet = false;
    hasSatellites = false;
    hasMobileNetworkTowers = false;

    // Notify listeners to update UI
    notifyListeners();
  }
}
