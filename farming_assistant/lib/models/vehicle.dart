import 'package:farming_assistant/models/user.dart';

class Vehicle{
  String id;
  String name;
  String description;
  String model;
  String brand;
  int year;
  double price;
  double kilometers;
  DateTime acquisitionDate;
  User user;

  Vehicle(this.id, this.name, this.description, this.model, this.brand, this.year, this.price, this.kilometers, this.acquisitionDate, this.user);

  static fromJson(Map <String, dynamic> jsonData) {
    return Vehicle(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['model'],
      jsonData['brand'],
      jsonData['year'],
      jsonData['price'],
      jsonData['kilometers'],
      jsonData['acquisitionDate'],
      User.fromJson(jsonData['user']),
    );
  }

  static toJson(Vehicle vehicle) {
    return {
      'id': vehicle.id,
      'name': vehicle.name,
      'description': vehicle.description,
      'model': vehicle.model,
      'brand': vehicle.brand,
      'year': vehicle.year,
      'price': vehicle.price,
      'kilometers': vehicle.kilometers,
      'acquisitionDate': vehicle.acquisitionDate,
      'user': User.toJson(vehicle.user),
    };
  }

}
