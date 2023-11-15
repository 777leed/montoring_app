class Livestock {
  String name;
  int number;

  Livestock({
    required this.name,
    required this.number,
  });

  factory Livestock.fromMap(Map<String, dynamic> data) {
    return Livestock(
      name: data['name'],
      number: data['number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
    };
  }
}
