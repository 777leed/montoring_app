class Population {
  final int populationDisplaced;
  final int populationDeath;
  final int populationInjured;

  Population({
    required this.populationDisplaced,
    required this.populationDeath,
    required this.populationInjured,
  });

  // Deserialize data from Firestore to a Population object
  factory Population.fromMap(Map<String, dynamic> data) {
    return Population(
      populationDisplaced: data['populationDisplaced'],
      populationDeath: data['populationDeath'],
      populationInjured: data['populationInjured'],
    );
  }

  // Serialize a Population object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'populationDisplaced': populationDisplaced,
      'populationDeath': populationDeath,
      'populationInjured': populationInjured,
    };
  }
}
