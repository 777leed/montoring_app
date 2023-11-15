class MyTrees {
  String type;
  int number;

  MyTrees({
    required this.type,
    required this.number,
  });

  factory MyTrees.fromMap(Map<String, dynamic> data) {
    return MyTrees(
      type: data['type'],
      number: data['number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'number': number,
    };
  }
}
