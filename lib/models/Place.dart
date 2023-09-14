import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:montoring_app/models/Supplies.dart';

class Place {
  final String name;
  final double latitude;
  final double longitude;
  final String status;
  final List<Supplies>? supplies;
  final List<Population>? population;
  final List<Infrastructure>? infrastructure;

  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.supplies,
    this.population,
    this.infrastructure,
  });

  // ... Other methods

  // Deserialize data from Firestore to a Place object
  factory Place.fromFirestore(Map<String, dynamic> data) {
    return Place(
      name: data['name'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      status: data['status'],
      supplies: (data['supplies'] as List<dynamic>?)
          ?.map((supply) => Supplies.fromMap(supply))
          .toList(),
      population: (data['population'] as List<dynamic>?)
          ?.map((pop) => Population.fromMap(pop))
          .toList(),
      infrastructure: (data['infrastructure'] as List<dynamic>?)
          ?.map((infra) => Infrastructure.fromMap(infra))
          .toList(),
    );
  }

  // Serialize a Place object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'supplies': supplies?.map((supply) => supply.toMap()).toList(),
      'population': population?.map((pop) => pop.toMap()).toList(),
      'infrastructure': infrastructure?.map((infra) => infra.toMap()).toList(),
    };
  }
}
