class Population {
  int totalMen;
  int totalWomen;
  int totalOlderBoys;
  int totalOlderGirls;
  int totalYoungerBoys;
  int totalYoungerGirls;

  int totalMenDisplaced;
  int totalWomenDisplaced;
  int totalBoysDisplaced;
  int totalGirlsDisplaced;

  int totalFamilies;
  int totalHouseholds;
  int totalPopulation;

  Population(
      {required this.totalPopulation,
      required this.totalMenDisplaced,
      required this.totalWomenDisplaced,
      required this.totalBoysDisplaced,
      required this.totalGirlsDisplaced,
      required this.totalMen,
      required this.totalWomen,
      required this.totalOlderBoys,
      required this.totalOlderGirls,
      required this.totalYoungerBoys,
      required this.totalYoungerGirls,
      required this.totalFamilies,
      required this.totalHouseholds});

  factory Population.initial() {
    return Population(
        totalMenDisplaced: 0,
        totalWomenDisplaced: 0,
        totalBoysDisplaced: 0,
        totalGirlsDisplaced: 0,
        totalPopulation: 0,
        totalMen: 0,
        totalWomen: 0,
        totalOlderBoys: 0,
        totalOlderGirls: 0,
        totalYoungerBoys: 0,
        totalYoungerGirls: 0,
        totalFamilies: 0,
        totalHouseholds: 0);
  }

  factory Population.fromMap(Map<String, dynamic> data) {
    return Population(
        totalMenDisplaced: data['totalMenDisplaced'],
        totalWomenDisplaced: data['totalWomenDisplaced'],
        totalBoysDisplaced: data['totalBoysDisplaced'],
        totalGirlsDisplaced: data['totalGirlsDisplaced'],
        totalMen: data['totalMen'],
        totalWomen: data['totalWomen'],
        totalOlderBoys: data['totalOlderBoys'],
        totalOlderGirls: data['totalOlderGirls'],
        totalYoungerBoys: data['totalYoungerBoys'],
        totalYoungerGirls: data['totalYoungerGirls'],
        totalPopulation: data['totalPopulation'],
        totalFamilies: data['totalFamilies'],
        totalHouseholds: data['totalHouseholds']);
  }
  Map<String, dynamic> toMap() {
    return {
      'totalMenDisplaced': totalMenDisplaced,
      'totalWomenDisplaced': totalWomenDisplaced,
      'totalBoysDisplaced': totalBoysDisplaced,
      'totalGirlsDisplaced': totalGirlsDisplaced,
      'totalMen': totalMen,
      'totalWomen': totalWomen,
      'totalOlderBoys': totalOlderBoys,
      'totalOlderGirls': totalOlderGirls,
      'totalYoungerBoys': totalYoungerBoys,
      'totalYoungerGirls': totalYoungerGirls,
      'totalPopulation': totalPopulation,
      'totalFamilies': totalFamilies,
      'totalHouseholds': totalHouseholds
    };
  }
}
