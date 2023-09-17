class Population {
  int populationDisplaced;
  int populationDeath;
  int populationInjured;
  int populationBeforeDisaster; // New field

  Population({
    required this.populationDisplaced,
    required this.populationDeath,
    required this.populationInjured,
    required this.populationBeforeDisaster, // New field
  });

  factory Population.fromMap(Map<String, dynamic> data) {
    return Population(
      populationDisplaced: data['populationDisplaced'],
      populationDeath: data['populationDeath'],
      populationInjured: data['populationInjured'],
      populationBeforeDisaster: data['populationBeforeDisaster'], // New field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'populationDisplaced': populationDisplaced,
      'populationDeath': populationDeath,
      'populationInjured': populationInjured,
      'populationBeforeDisaster': populationBeforeDisaster, // New field
    };
  }
}
