class Contacts {
  final String? id; // Unique identifier for the contact
  final String name; // Contact's name
  final String phoneNumber; // Contact's phone number
  final String email; // Contact's email address

  Contacts({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  // Create a factory constructor to deserialize from a map
  factory Contacts.fromMap(Map<String, dynamic> map) {
    return Contacts(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
  }

  // Create a method to serialize to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }
}
