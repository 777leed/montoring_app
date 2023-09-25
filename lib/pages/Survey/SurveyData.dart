import 'package:flutter/material.dart';
import 'package:montoring_app/models/Contacts.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Population.dart';

class SurveyDataProvider extends ChangeNotifier {
  List<String> imagePaths = [];

  int totalMenBefore = 0;
  int totalWomenBefore = 0;
  int totalBoysBefore = 0;
  int totalGirlsBefore = 0;

  int totalMenDeaths = 0;
  int totalWomenDeaths = 0;
  int totalBoysDeaths = 0;
  int totalGirlsDeaths = 0;

  int totalMenInjured = 0;
  int totalWomenInjured = 0;
  int totalBoysInjured = 0;
  int totalGirlsInjured = 0;

  int totalMenDisplaced = 0;
  int totalWomenDisplaced = 0;
  int totalBoysDisplaced = 0;
  int totalGirlsDisplaced = 0;

  int totalLivestockAnimals = 0;

  List<Contacts> contacts = [];

  int totalHomesDemolished = 0;
  int totalHomesUnstable = 0;
  int totalHomesIntact = 0;

  int totalMosquesDemolished = 0;
  int totalMosquesUnstable = 0;
  int totalMosquesIntact = 0;

  int totalSchoolsDemolished = 0;
  int totalSchoolsUnstable = 0;
  int totalSchoolsIntact = 0;

  int totalStoresDemolished = 0;
  int totalStoresUnstable = 0;
  int totalStoresIntact = 0;

  String roadStatus = "Stable";
  String roadName = "";
  String roadVehicleType = "N/A";

  String waterStatus = "Available";
  String electricityStatus = "Available";
  String selectedStatus = "Unknown";

  Map<String, dynamic> currentSupplies = {
    'Tents': '',
    'Blankets': '',
    'Cushions': '',
    'Pallets': '',
    'Food': 'Unknown',
    'Construction Materials for Building Rehab': 'Unknown',
    'Hygiene Products': 'Unknown',
    'Medicine/First Aid': 'Unknown',
  };

  Map<String, dynamic> neededSupplies = {
    'Tents': '',
    'Blankets': '',
    'Cushions': '',
    'Pallets': '',
    'Food': 'Unknown',
    'Construction Materials for Building Rehab': 'Unknown',
    'Hygiene Products': 'Unknown',
    'Medicine/First Aid': 'Unknown',
  };

  void addImagePath(String path) {
    imagePaths.add(path);
    notifyListeners();
  }

  Population getPopulation() {
    return Population(
        totalMenBefore: totalMenBefore,
        totalWomenBefore: totalWomenBefore,
        totalBoysBefore: totalBoysBefore,
        totalGirlsBefore: totalGirlsBefore,
        totalMenDeaths: totalMenDeaths,
        totalWomenDeaths: totalWomenDeaths,
        totalBoysDeaths: totalBoysDeaths,
        totalGirlsDeaths: totalGirlsDeaths,
        totalMenInjured: totalMenInjured,
        totalWomenInjured: totalWomenInjured,
        totalBoysInjured: totalBoysInjured,
        totalGirlsInjured: totalGirlsInjured,
        totalMenDisplaced: totalMenDisplaced,
        totalWomenDisplaced: totalWomenDisplaced,
        totalBoysDisplaced: totalBoysDisplaced,
        totalGirlsDisplaced: totalGirlsDisplaced,
        totalLivestockAnimals: totalLivestockAnimals);
  }

  Infrastructure getInfrastructure() {
    return Infrastructure(
      totalHomesDemolished: totalHomesDemolished,
      totalHomesUnstable: totalHomesUnstable,
      totalHomesIntact: totalHomesIntact,
      totalMosquesDemolished: totalMosquesDemolished,
      totalMosquesUnstable: totalMosquesUnstable,
      totalMosquesIntact: totalMosquesIntact,
      totalSchoolsDemolished: totalSchoolsDemolished,
      totalSchoolsUnstable: totalSchoolsUnstable,
      totalSchoolsIntact: totalSchoolsIntact,
      totalStoresDemolished: totalStoresDemolished,
      totalStoresUnstable: totalStoresUnstable,
      totalStoresIntact: totalStoresIntact,
      roadStatus: roadStatus,
      roadName: roadName,
      roadVehicleType: roadVehicleType,
      waterStatus: waterStatus,
      electricityStatus: electricityStatus,
      selectedStatus: selectedStatus,
    );
  }

  void updateTotalMenBefore(int newValue) {
    totalMenBefore = newValue;
    notifyListeners();
  }

  void updateContancts(List<Contacts> newValue) {
    contacts = newValue;
    notifyListeners();
  }

  void updateTotalWomenBefore(int newValue) {
    totalWomenBefore = newValue;
    notifyListeners();
  }

  void updateTotalBoysBefore(int newValue) {
    totalBoysBefore = newValue;
    notifyListeners();
  }

  void updateTotalGirlsBefore(int newValue) {
    totalGirlsBefore = newValue;
    notifyListeners();
  }

  void updateTotalMenDeaths(int newValue) {
    totalMenDeaths = newValue;
    notifyListeners();
  }

  void updateTotalWomenDeaths(int newValue) {
    totalWomenDeaths = newValue;
    notifyListeners();
  }

  void updateTotalBoysDeaths(int newValue) {
    totalBoysDeaths = newValue;
    notifyListeners();
  }

  void updateTotalGirlsDeaths(int newValue) {
    totalGirlsDeaths = newValue;
    notifyListeners();
  }

  void updateTotalMenInjured(int newValue) {
    totalMenInjured = newValue;
    notifyListeners();
  }

  void updateTotalWomenInjured(int newValue) {
    totalWomenInjured = newValue;
    notifyListeners();
  }

  void updateTotalBoysInjured(int newValue) {
    totalBoysInjured = newValue;
    notifyListeners();
  }

  void updateTotalGirlsInjured(int newValue) {
    totalGirlsInjured = newValue;
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

  void updateTotalHomesDemolished(int newValue) {
    totalHomesDemolished = newValue;
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

  void updateTotalMosquesDemolished(int newValue) {
    totalMosquesDemolished = newValue;
    notifyListeners();
  }

  void updateTotalMosquesUnstable(int newValue) {
    totalMosquesUnstable = newValue;
    notifyListeners();
  }

  void updateTotalMosquesIntact(int newValue) {
    totalMosquesIntact = newValue;
    notifyListeners();
  }

  void updateTotalSchoolsDemolished(int newValue) {
    totalSchoolsDemolished = newValue;
    notifyListeners();
  }

  void updateTotalSchoolsUnstable(int newValue) {
    totalSchoolsUnstable = newValue;
    notifyListeners();
  }

  void updateTotalSchoolsIntact(int newValue) {
    totalSchoolsIntact = newValue;
    notifyListeners();
  }

  void updateTotalStoresDemolished(int newValue) {
    totalStoresDemolished = newValue;
    notifyListeners();
  }

  void updateTotalStoresUnstable(int newValue) {
    totalStoresUnstable = newValue;
    notifyListeners();
  }

  void updateTotalStoresIntact(int newValue) {
    totalStoresIntact = newValue;
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

  void updateCurrentSupplies(String key, dynamic value) {
    currentSupplies[key] = value;
    notifyListeners();
  }

  void updateNeededSupplies(String key, dynamic value) {
    neededSupplies[key] = value;
    notifyListeners();
  }

  void resetData() {
    // Reset population data
    totalMenBefore = 0;
    totalWomenBefore = 0;
    totalBoysBefore = 0;
    totalGirlsBefore = 0;
    totalMenDeaths = 0;
    totalWomenDeaths = 0;
    totalBoysDeaths = 0;
    totalGirlsDeaths = 0;
    totalMenInjured = 0;
    totalWomenInjured = 0;
    totalBoysInjured = 0;
    totalGirlsInjured = 0;
    totalMenDisplaced = 0;
    totalWomenDisplaced = 0;
    totalBoysDisplaced = 0;
    totalGirlsDisplaced = 0;
    totalLivestockAnimals = 0;

    // Reset contacts
    contacts.clear();

    // Reset infrastructure data
    totalHomesDemolished = 0;
    totalHomesUnstable = 0;
    totalHomesIntact = 0;
    totalMosquesDemolished = 0;
    totalMosquesUnstable = 0;
    totalMosquesIntact = 0;
    totalSchoolsDemolished = 0;
    totalSchoolsUnstable = 0;
    totalSchoolsIntact = 0;
    totalStoresDemolished = 0;
    totalStoresUnstable = 0;
    totalStoresIntact = 0;
    roadStatus = "Stable";
    roadName = "";
    roadVehicleType = "N/A";
    waterStatus = "Available";
    electricityStatus = "Available";
    selectedStatus = "Unknown";

    // Reset supplies
    currentSupplies = {
      'Tents': '',
      'Blankets': '',
      'Cushions': '',
      'Pallets': '',
      'Food': 'Unknown',
      'Construction Materials for Building Rehab': 'Unknown',
      'Hygiene Products': 'Unknown',
      'Medicine/First Aid': 'Unknown',
    };

    neededSupplies = {
      'Tents': '',
      'Blankets': '',
      'Cushions': '',
      'Pallets': '',
      'Food': 'Unknown',
      'Construction Materials for Building Rehab': 'Unknown',
      'Hygiene Products': 'Unknown',
      'Medicine/First Aid': 'Unknown',
    };

    // Reset image paths
    imagePaths.clear();

    // Notify listeners to update UI
    notifyListeners();
  }

  @override
  String toString() {
    return '''
      Survey Data:
      Total Men Before: $totalMenBefore
      Total Women Before: $totalWomenBefore
      Total Boys Before: $totalBoysBefore
      Total Girls Before: $totalGirlsBefore

      Total Men Deaths: $totalMenDeaths
      Total Women Deaths: $totalWomenDeaths
      Total Boys Deaths: $totalBoysDeaths
      Total Girls Deaths: $totalGirlsDeaths

      Total Men Injured: $totalMenInjured
      Total Women Injured: $totalWomenInjured
      Total Boys Injured: $totalBoysInjured
      Total Girls Injured: $totalGirlsInjured

      Total Men Displaced: $totalMenDisplaced
      Total Women Displaced: $totalWomenDisplaced
      Total Boys Displaced: $totalBoysDisplaced
      Total Girls Displaced: $totalGirlsDisplaced

      Total Livestock Animals: $totalLivestockAnimals

      Total Homes Demolished: $totalHomesDemolished
      Total Homes Unstable: $totalHomesUnstable
      Total Homes Intact: $totalHomesIntact

      Total Mosques Demolished: $totalMosquesDemolished
      Total Mosques Unstable: $totalMosquesUnstable
      Total Mosques Intact: $totalMosquesIntact

      Total Schools Demolished: $totalSchoolsDemolished
      Total Schools Unstable: $totalSchoolsUnstable
      Total Schools Intact: $totalSchoolsIntact

      Total Stores Demolished: $totalStoresDemolished
      Total Stores Unstable: $totalStoresUnstable
      Total Stores Intact: $totalStoresIntact

      Road Status: $roadStatus
      Road Name: $roadName
      Road Vehicle Type: $roadVehicleType

      Water Status: $waterStatus
      Electricity Status: $electricityStatus
      Selected Status: $selectedStatus

      Current Supplies: $currentSupplies
      Needed Supplies: $neededSupplies
    ''';
  }
}
