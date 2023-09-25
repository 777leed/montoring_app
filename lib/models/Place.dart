import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:montoring_app/models/Supplies.dart';
import 'package:montoring_app/models/Contacts.dart';

class Place {
  String name;
  double latitude;
  double longitude;
  String status;
  List<String>? needs;
  List<Supplies>? supplies;
  Population? population;
  Infrastructure? infrastructure;
  List<Contacts>? contacts;
  String addedBy;
  Map<String, dynamic>? currentSupplies;
  Map<String, dynamic>? neededSupplies;
  List<String>? images;

  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.needs,
    this.supplies,
    this.population,
    this.infrastructure,
    this.contacts,
    this.currentSupplies,
    this.neededSupplies,
    this.images,
    required this.addedBy,
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
        infrastructure: Infrastructure.fromMap(data['infrastructure'] ?? {}),
        contacts: (data['contacts'] as List<dynamic>?)
            ?.map((contact) => Contacts.fromMap(contact))
            .toList(),
        addedBy: data['AddedBy'],
        currentSupplies:
            (data['currentSupplies'] as Map<String, dynamic>?) ?? {},
        neededSupplies: (data['neededSupplies'] as Map<String, dynamic>?) ?? {},
        images: List<String>.from(data['images'] ?? []));
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
      'infrastructure': infrastructure!.toMap(),
      'contacts': contacts?.map((contact) => contact.toMap()).toList(),
      'addedBy': addedBy,
      'currentSupplies': currentSupplies,
      'neededSupplies': neededSupplies,
      'images': images
    };
  }
}
