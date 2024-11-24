import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'location.dart';

class Animal {
  String id;
  String name;
  String description;
  DateTime age;
  Uint8List imageData;
  String health_profile;
  Location location;


  Animal(this.id, this.name, this.description, this.age, this.imageData, this.health_profile, this.location);


  static fromJson(jsonData) {
    return Animal(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      DateTime.parse(jsonData['age']),
      jsonData['image_data'],
      jsonData['health_profile'],
      Location.fromJson(jsonData['location'])
    );
  }

  static toJson(Animal animal) {
    return {
      'id': animal.id,
      'name': animal.name,
      'description': animal.description,
      'age': animal.age.toString(),
      'image_data': animal.imageData,
      'health_profile': animal.health_profile,
      'location': Location.toJson(animal.location),
    };
  }


}
