import 'package:montoring_app/models/MyBuilding.dart';
import 'package:montoring_app/models/MyRoads.dart';

class Infrastructure {
  int totalHomes = 0;
  int totalHomesUnstable = 0;
  int totalHomesIntact = 0;

  List<MyRoads>? roadList = [];

  bool hasRunningWater = false;
  bool hasWell = false;
  bool hasSinks = false;
  bool usesNaturalSources = false;
  bool isWaterAvailable = true;
  String notAvailableReason = "";
  bool isElectricityAvailable = true;
  String electricityNotAvailableReason = "";
  bool hasInternet = false;
  bool hasSatellites = false;
  bool hasMobileNetworkTowers = false;

  List<MyBuilding>? buildings = [];

  Infrastructure({
    required this.totalHomes,
    required this.totalHomesUnstable,
    required this.totalHomesIntact,
    required this.roadList,
    required this.buildings,
    required this.hasRunningWater,
    required this.isWaterAvailable,
    required this.isElectricityAvailable,
    required this.usesNaturalSources,
    required this.notAvailableReason,
    required this.hasWell,
    required this.hasSinks,
    required this.electricityNotAvailableReason,
    required this.hasInternet,
    required this.hasMobileNetworkTowers,
    required this.hasSatellites,
  });

  Infrastructure.initial() {
    totalHomes = 0;
    totalHomesUnstable = 0;
    totalHomesIntact = 0;
  }

  factory Infrastructure.fromMap(Map<String, dynamic> data) {
    return Infrastructure(
      totalHomes: data['totalHomes'],
      totalHomesUnstable: data['totalHomesUnstable'],
      totalHomesIntact: data['totalHomesIntact'],
      roadList: (data['roadList'] as List<dynamic>?)
          ?.map((road) => MyRoads.fromMap(road))
          .toList(),
      buildings: (data['buildings'] as List<dynamic>?)
          ?.map((building) => MyBuilding.fromMap(building))
          .toList(),
      hasRunningWater: data['hasRunningWater'] ?? false,
      isWaterAvailable: data['isWaterAvailable'] ?? true,
      isElectricityAvailable: data['isWaterAvailable'] ?? true,
      usesNaturalSources: data['usesNaturalSources'] ?? false,
      notAvailableReason: data['notAvailableReason'] ?? "",
      hasWell: data['hasWell'] ?? false,
      hasSinks: data['hasSinks'] ?? false,
      electricityNotAvailableReason:
          data['electricityNotAvailableReason'] ?? "",
      hasInternet: data['hasInternet'] ?? false,
      hasMobileNetworkTowers: data['hasMobileNetworkTowers'] ?? false,
      hasSatellites: data['hasSatellites'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalHomes': totalHomes,
      'totalHomesUnstable': totalHomesUnstable,
      'totalHomesIntact': totalHomesIntact,
      'roadList': roadList?.map((road) => road.toMap()).toList(),
      'buildings': buildings?.map((buildings) => buildings.toMap()).toList(),
      'hasRunningWater': hasRunningWater,
      'isWaterAvailable': isWaterAvailable,
      'isElectricityAvailable': isElectricityAvailable,
      'usesNaturalSources': usesNaturalSources,
      'notAvailableReason': notAvailableReason,
      'hasWell': hasWell,
      'hasSinks': hasSinks,
      'electricityNotAvailableReason': electricityNotAvailableReason,
      'hasInternet': hasInternet,
      'hasMobileNetworkTowers': hasMobileNetworkTowers,
      'hasSatellites': hasSatellites,
    };
  }
}
