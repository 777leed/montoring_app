class MyCrafts {
  String typeOfCraft;
  int numberOfMen;
  int numberOfWomen;

  MyCrafts({
    required this.typeOfCraft,
    required this.numberOfMen,
    required this.numberOfWomen,
  });

  factory MyCrafts.fromMap(Map<String, dynamic> data) {
    return MyCrafts(
      typeOfCraft: data['typeOfCraft'],
      numberOfMen: data['numberOfMen'],
      numberOfWomen: data['numberOfWomen'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'typeOfCraft': typeOfCraft,
      'numberOfMen': numberOfMen,
      'numberOfWomen': numberOfWomen,
    };
  }
}
