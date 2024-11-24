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

  static fromJson(jsonData) {
    return Vehicle(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['model'],
      jsonData['brand'],
      jsonData['year'],
      jsonData['price'],
      jsonData['kilometers'],
      jsonData['acquisition_date'],
      User.fromJson(jsonData['user']),
    );
  }

}