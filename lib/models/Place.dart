import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:montoring_app/models/Supplies.dart';
import 'package:montoring_app/models/Contacts.dart'; // Import the Contacts model

class Place {
  String name;
  double latitude;
  double longitude;
  String status;
  final List<String> needs;
  List<Supplies>? supplies;
  Population? population;
  List<Infrastructure>? infrastructure;
  List<Contacts>? contacts; // Add a List<Contacts> field

  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.needs,
    this.supplies,
    this.population,
    this.infrastructure,
    this.contacts, // Initialize the contacts field
  });

  factory Place.fromFirestore(Map<String, dynamic> data) {
    return Place(
      name: data['name'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      status: data['status'],
      needs: List<String>.from(data['needs'] ?? []),
      supplies: (data['supplies'] as List<dynamic>?)
          ?.map((supply) => Supplies.fromMap(supply))
          .toList(),
      population: data['population'] != null
          ? Population.fromMap(data['population'])
          : null,
      infrastructure: (data['infrastructure'] as List<dynamic>?)
          ?.map((infra) => Infrastructure.fromMap(infra))
          .toList(),
      contacts: (data['contacts'] as List<dynamic>?)
          ?.map((contact) => Contacts.fromMap(contact))
          .toList(), // Deserialize contacts data
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'needs': needs,
      'supplies': supplies?.map((supply) => supply.toMap()).toList(),
      'population': population != null ? population!.toMap() : null,
      'infrastructure': infrastructure?.map((infra) => infra.toMap()).toList(),
      'contacts': contacts
          ?.map((contact) => contact.toMap())
          .toList(), // Serialize contacts data
    };
  }
}
