class Contacts {
  final String? id;
  final String name;
  final String phoneNumber;
  final String email;
  final String prefered;

  Contacts(
      {this.id,
      required this.name,
      required this.phoneNumber,
      required this.email,
      required this.prefered});

  factory Contacts.fromMap(Map<String, dynamic> map) {
    return Contacts(
        id: map['id'],
        name: map['name'],
        phoneNumber: map['phoneNumber'],
        email: map['email'],
        prefered: map['prefered']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'prefered': prefered
    };
  }

  @override
  String toString() {
    return 'Name: $name, Phone number: $phoneNumber, Email: $email, Prefered: $prefered';
  }
}
