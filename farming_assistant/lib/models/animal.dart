import 'dart:typed_data';

import '../utils/date_time_formater.dart';
import 'location.dart';


/// Animal model
/// Represents an animal in the database with the following fields:
/// - id: UUID - unique identifier of the animal (primary key)
/// - name: String - name of the animal (e.g. Rex)
/// - description: String - description of the animal (e.g. breed, color)
/// - age: DateTime - date of birth of the animal (if known)
/// - imageData: Uint8List - image of the animal in byte format(optional)
/// - healthProfile: String - health profile of the animal (e.g. vaccinated, neutered)
/// - location: Location - location of the animal (foreign key)
class Animal {
  String id;
  String name;
  String description;
  DateTime age;
  Uint8List? imageData;
  String healthProfile;
  Location location;


  Animal(this.id, this.name, this.description, this.age, this.imageData, this.healthProfile, this.location);


  static fromJson(Map <String, dynamic> jsonData) {
    return Animal(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      DateTime.parse(jsonData['age']),
      jsonData['imageData'] == null ? null : Uint8List.fromList(jsonData['imageData'].cast<int>()),
      jsonData['healthProfile'],
      Location.fromJson(jsonData['location'])
    );
  }

  static toJson(Animal animal) {
    return {
      'id': animal.id,
      'name': animal.name,
      'description': animal.description,
      'age':  formatDateTimeString(animal.age),
      'imageData': animal.imageData,
      'healthProfile': animal.healthProfile,
      'location': Location.toJson(animal.location),
    };
  }


}
