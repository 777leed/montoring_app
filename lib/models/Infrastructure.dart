class Infrastructure {
  List<int> homeStatistics = [
    0,
    0,
    0,
    0
  ]; // [Total, Lost, Unstable & Need Rehab, Stable]
  List<int> schoolStatistics = [
    0,
    0,
    0,
    0
  ]; // [Total, Lost, Unstable & Need Rehab, Stable]
  List<int> mosqueStatistics = [
    0,
    0,
    0,
    0
  ]; // [Total, Lost, Unstable & Need Rehab, Stable]
  List<int> roadStatistics = [
    0,
    0,
    0,
    0
  ]; // [Total, Lost, Unstable & Need Rehab, Stable]
  List<int> storeStatistics = [
    0,
    0,
    0,
    0
  ]; // [Total, Lost, Unstable & Need Rehab, Stable]

  Infrastructure({
    required this.homeStatistics,
    required this.schoolStatistics,
    required this.mosqueStatistics,
    required this.roadStatistics,
    required this.storeStatistics,
  });

  factory Infrastructure.fromMap(Map<String, dynamic> data) {
    return Infrastructure(
      homeStatistics: List<int>.from(data['homeStatistics'] ?? [0, 0, 0, 0]),
      schoolStatistics:
          List<int>.from(data['schoolStatistics'] ?? [0, 0, 0, 0]),
      mosqueStatistics:
          List<int>.from(data['mosqueStatistics'] ?? [0, 0, 0, 0]),
      roadStatistics: List<int>.from(data['roadStatistics'] ?? [0, 0, 0, 0]),
      storeStatistics: List<int>.from(data['storeStatistics'] ?? [0, 0, 0, 0]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'homeStatistics': homeStatistics,
      'schoolStatistics': schoolStatistics,
      'mosqueStatistics': mosqueStatistics,
      'roadStatistics': roadStatistics,
      'storeStatistics': storeStatistics,
    };
  }
}
