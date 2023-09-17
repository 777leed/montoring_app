class Contacts {
  final String? id;
  final String name;
  final String phoneNumber;
  final String email;

  Contacts({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  factory Contacts.fromMap(Map<String, dynamic> map) {
    return Contacts(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'Name: $name, Phone number: $phoneNumber, Email: $email';
  }
}
