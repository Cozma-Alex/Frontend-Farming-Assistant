import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import '../utils/date_time_formater.dart';
import 'location.dart';

class Animal {
  String id;
  String name;
  String description;
  DateTime age;
  Uint8List imageData;
  String healthProfile;
  Location location;


  Animal(this.id, this.name, this.description, this.age, this.imageData, this.healthProfile, this.location);


  static fromJson(Map <String, dynamic> jsonData) {
    return Animal(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      DateTime.parse(jsonData['age']),
      jsonData['imageData'],
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
