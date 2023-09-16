class Population {
  int populationDisplaced;
  int populationDeath;
  int populationInjured;

  Population({
    required this.populationDisplaced,
    required this.populationDeath,
    required this.populationInjured,
  });

  factory Population.fromMap(Map<String, dynamic> data) {
    return Population(
      populationDisplaced: data['populationDisplaced'],
      populationDeath: data['populationDeath'],
      populationInjured: data['populationInjured'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'populationDisplaced': populationDisplaced,
      'populationDeath': populationDeath,
      'populationInjured': populationInjured,
    };
  }
}
