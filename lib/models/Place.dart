import 'package:montoring_app/models/EducationStatistics.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/IrrigationSystem.dart';
import 'package:montoring_app/models/LiveStock.dart';
import 'package:montoring_app/models/MyHerbs.dart';
import 'package:montoring_app/models/MyNeeds.dart';
import 'package:montoring_app/models/MyTrees.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:montoring_app/models/Supplies.dart';
import 'package:montoring_app/models/Contacts.dart';
import 'package:montoring_app/models/coordinates.dart';
import 'package:montoring_app/models/MyCrafts.dart';

class Place {
  String? id;
  String name;
  MyCoordinates? coordinates;
  String? status;
  List<Supplies>? supplies;
  Population? population;
  List<MyCrafts>? crafts;
  Infrastructure? infrastructure;
  List<Contacts>? contacts;
  EducationStatistics? educationStatistics;
  String? addedBy;
  List<String>? images;
  List<MyTrees>? trees;
  List<IrrigationSystem>? irrigationSystems;
  List<Livestock>? animals;
  List<Myherbs>? myHerbs;
  List<MyNeeds>? myNeeds;
  double landSize;
  double irrigatedLands;
  double barrenLands;
  bool subsistence;
  bool financial;
  bool belongsToubkal;
  String village;
  String valley;
  String commune;
  String province;

  Place({
    this.id,
    required this.name,
    this.coordinates,
    required this.status,
    required this.supplies,
    required this.population,
    required this.crafts,
    required this.educationStatistics,
    required this.infrastructure,
    required this.contacts,
    required this.images,
    this.addedBy,
    required this.myNeeds,
    required this.trees,
    required this.irrigationSystems,
    required this.animals,
    required this.myHerbs,
    required this.irrigatedLands,
    required this.landSize,
    required this.barrenLands,
    required this.subsistence,
    required this.financial,
    required this.belongsToubkal,
    required this.village,
    required this.valley,
    required this.commune,
    required this.province,
  });

  factory Place.fromFirestore(Map<String, dynamic> data) {
    return Place(
      id: data['id'],
      name: data['name'],
      coordinates: MyCoordinates.fromMap(data['coordinates'] ?? {}),
      status: data['status'],
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
      trees: (data['trees'] as List<dynamic>?)
          ?.map((tree) => MyTrees.fromMap(tree))
          .toList(),
      animals: (data['animals'] as List<dynamic>?)
          ?.map((animal) => Livestock.fromMap(animal))
          .toList(),
      myHerbs: (data['myHerbs'] as List<dynamic>?)
          ?.map((herb) => Myherbs.fromMap(herb))
          .toList(),
      irrigationSystems: (data['irrigationSystems'] as List<dynamic>?)
          ?.map(
              (irrigationSystem) => IrrigationSystem.fromMap(irrigationSystem))
          .toList(),
      crafts: (data['crafts'] as List<dynamic>?)
          ?.map((craft) => MyCrafts.fromMap(craft))
          .toList(),
      myNeeds: (data['needs'] as List<dynamic>?)
          ?.map((need) => MyNeeds.fromMap(need))
          .toList(),
      addedBy: data['AddedBy'],
      images: List<String>.from(data['images'] ?? []),
      educationStatistics:
          EducationStatistics.fromMap(data['educationStatistics'] ?? {}),
      irrigatedLands: data['irrigatedLands'],
      landSize: data['landSize'],
      barrenLands: data['barrenLands'],
      subsistence: data['subsistence'],
      financial: data['financial'],
      belongsToubkal: data['belongsToubkal'],
      village: data['village'],
      valley: data['valley'],
      commune: data['commune'],
      province: data['province'],
    );
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'coordinates': coordinates != null ? coordinates!.toMap() : null,
      'status': status,
      'supplies': supplies?.map((supply) => supply.toMap()).toList(),
      'population': population != null ? population!.toMap() : null,
      'infrastructure': infrastructure != null ? infrastructure!.toMap() : null,
      'contacts': contacts?.map((contact) => contact.toMap()).toList(),
      'trees': trees?.map((trees) => trees.toMap()).toList(),
      'irrigationSystems': irrigationSystems
          ?.map((irrigationSystem) => irrigationSystem.toMap())
          .toList(),
      'animals': animals?.map((animal) => animal.toMap()).toList(),
      'myHerbs': myHerbs?.map((herb) => herb.toMap()).toList(),
      'addedBy': addedBy,
      'needs': myNeeds?.map((need) => need.toMap()).toList(),
      'images': images,
      'crafts': crafts?.map((craft) => craft.toMap()).toList(),
      'educationStatistics':
          educationStatistics != null ? educationStatistics!.toMap() : null,
      'irrigatedLands': irrigatedLands,
      'landSize': landSize,
      'barrenLands': barrenLands,
      'subsistence': subsistence,
      'financial': financial,
      'belongsToubkal': belongsToubkal,
      'village': village,
      'valley': valley,
      'commune': commune,
      'province': province,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
