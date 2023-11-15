class Myherbs {
  String name;

  Myherbs({
    required this.name,
  });

  factory Myherbs.fromMap(Map<String, dynamic> data) {
    return Myherbs(
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
