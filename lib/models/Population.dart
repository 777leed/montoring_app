class Population {
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

  Population({
    this.totalMenBefore = 0,
    this.totalWomenBefore = 0,
    this.totalBoysBefore = 0,
    this.totalGirlsBefore = 0,
    this.totalMenDeaths = 0,
    this.totalWomenDeaths = 0,
    this.totalBoysDeaths = 0,
    this.totalGirlsDeaths = 0,
    this.totalMenInjured = 0,
    this.totalWomenInjured = 0,
    this.totalBoysInjured = 0,
    this.totalGirlsInjured = 0,
    this.totalMenDisplaced = 0,
    this.totalWomenDisplaced = 0,
    this.totalBoysDisplaced = 0,
    this.totalGirlsDisplaced = 0,
    this.totalLivestockAnimals = 0,
  });

  factory Population.fromMap(Map<String, dynamic> data) {
    return Population(
      totalMenBefore: data['totalMenBefore'],
      totalWomenBefore: data['totalWomenBefore'],
      totalBoysBefore: data['totalBoysBefore'],
      totalGirlsBefore: data['totalGirlsBefore'],
      totalMenDeaths: data['totalMenDeaths'],
      totalWomenDeaths: data['totalWomenDeaths'],
      totalBoysDeaths: data['totalBoysDeaths'],
      totalGirlsDeaths: data['totalGirlsDeaths'],
      totalMenInjured: data['totalMenInjured'],
      totalWomenInjured: data['totalWomenInjured'],
      totalBoysInjured: data['totalBoysInjured'],
      totalGirlsInjured: data['totalGirlsInjured'],
      totalMenDisplaced: data['totalMenDisplaced'],
      totalWomenDisplaced: data['totalWomenDisplaced'],
      totalBoysDisplaced: data['totalBoysDisplaced'],
      totalGirlsDisplaced: data['totalGirlsDisplaced'],
      totalLivestockAnimals: data['totalLivestockAnimals'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalMenBefore': totalMenBefore,
      'totalWomenBefore': totalWomenBefore,
      'totalBoysBefore': totalBoysBefore,
      'totalGirlsBefore': totalGirlsBefore,
      'totalMenDeaths': totalMenDeaths,
      'totalWomenDeaths': totalWomenDeaths,
      'totalBoysDeaths': totalBoysDeaths,
      'totalGirlsDeaths': totalGirlsDeaths,
      'totalMenInjured': totalMenInjured,
      'totalWomenInjured': totalWomenInjured,
      'totalBoysInjured': totalBoysInjured,
      'totalGirlsInjured': totalGirlsInjured,
      'totalMenDisplaced': totalMenDisplaced,
      'totalWomenDisplaced': totalWomenDisplaced,
      'totalBoysDisplaced': totalBoysDisplaced,
      'totalGirlsDisplaced': totalGirlsDisplaced,
      'totalLivestockAnimals': totalLivestockAnimals,
    };
  }
}
