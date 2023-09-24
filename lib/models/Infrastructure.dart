class Infrastructure {
  int totalHomesDemolished = 0;
  int totalHomesUnstable = 0;
  int totalHomesIntact = 0; // Updated field name

  int totalMosquesDemolished = 0;
  int totalMosquesUnstable = 0;
  int totalMosquesIntact = 0; // Updated field name

  int totalSchoolsDemolished = 0;
  int totalSchoolsUnstable = 0;
  int totalSchoolsIntact = 0; // Updated field name

  int totalStoresDemolished = 0;
  int totalStoresUnstable = 0;
  int totalStoresIntact = 0; // Updated field name

  String roadStatus = "Stable";
  String roadName = "";
  String roadVehicleType = "N/A";

  String waterStatus = "Available";
  String electricityStatus = "Available";
  String selectedStatus = "Unknown";

  Infrastructure({
    required this.totalHomesDemolished,
    required this.totalHomesUnstable,
    required this.totalHomesIntact,
    required this.totalMosquesDemolished,
    required this.totalMosquesUnstable,
    required this.totalMosquesIntact,
    required this.totalSchoolsDemolished,
    required this.totalSchoolsUnstable,
    required this.totalSchoolsIntact,
    required this.totalStoresDemolished,
    required this.totalStoresUnstable,
    required this.totalStoresIntact,
    required this.roadStatus,
    required this.roadName,
    required this.roadVehicleType,
    required this.waterStatus,
    required this.electricityStatus,
    required this.selectedStatus,
  });

  Infrastructure.initial() {
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
  }

  factory Infrastructure.fromMap(Map<String, dynamic> data) {
    return Infrastructure(
      totalHomesDemolished: data['totalHomesDemolished'],
      totalHomesUnstable: data['totalHomesUnstable'],
      totalHomesIntact: data['totalHomesIntact'],
      totalMosquesDemolished: data['totalMosquesDemolished'],
      totalMosquesUnstable: data['totalMosquesUnstable'],
      totalMosquesIntact: data['totalMosquesIntact'],
      totalSchoolsDemolished: data['totalSchoolsDemolished'],
      totalSchoolsUnstable: data['totalSchoolsUnstable'],
      totalSchoolsIntact: data['totalSchoolsIntact'],
      totalStoresDemolished: data['totalStoresDemolished'],
      totalStoresUnstable: data['totalStoresUnstable'],
      totalStoresIntact: data['totalStoresIntact'],
      roadStatus: data['roadStatus'] ?? "Stable",
      roadName: data['roadName'] ?? "",
      roadVehicleType: data['roadVehicleType'] ?? "N/A",
      waterStatus: data['waterStatus'] ?? "Available",
      electricityStatus: data['electricityStatus'] ?? "Available",
      selectedStatus: data['selectedStatus'] ?? "Unknown",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalHomesDemolished': totalHomesDemolished,
      'totalHomesUnstable': totalHomesUnstable,
      'totalHomesIntact': totalHomesIntact,
      'totalMosquesDemolished': totalMosquesDemolished,
      'totalMosquesUnstable': totalMosquesUnstable,
      'totalMosquesIntact': totalMosquesIntact,
      'totalSchoolsDemolished': totalSchoolsDemolished,
      'totalSchoolsUnstable': totalSchoolsUnstable,
      'totalSchoolsIntact': totalSchoolsIntact,
      'totalStoresDemolished': totalStoresDemolished,
      'totalStoresUnstable': totalStoresUnstable,
      'totalStoresIntact': totalStoresIntact,
      'roadStatus': roadStatus,
      'roadName': roadName,
      'roadVehicleType': roadVehicleType,
      'waterStatus': waterStatus,
      'electricityStatus': electricityStatus,
      'selectedStatus': selectedStatus,
    };
  }
}
