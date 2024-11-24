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
  Uint8List image_data;


  Animal(this.id, this.name, this.description, this.age, this.imageData, this.health_profile, this.location, this.image_data);


  static fromJson(jsonData) {
    return Animal(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      DateTime.parse(jsonData['age']),
      jsonData['image_data'],
      jsonData['health_profile'],
      Location.fromJson(jsonData['location']),
      jsonData['image_data'],
    );
  }


}
