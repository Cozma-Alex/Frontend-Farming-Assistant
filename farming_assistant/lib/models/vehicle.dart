import 'package:farming_assistant/models/user.dart';

/// Vehicle model
/// Represents a vehicle in the database with the following fields:
/// - id: UUID - the unique identifier of the vehicle (primary key)
/// - name: String - the name of the vehicle (not null, max 150 characters)
/// - description: String - the description of the vehicle (max 255 characters)
/// - model: String - the model of the vehicle (max 100 characters)
/// - brand: String - the brand of the vehicle (max 100 characters)
/// - year: int - the year of the vehicle
/// - price: double - the price of the vehicle
/// - kilometers: double - the number of kilometers of the vehicle
/// - acquisitionDate: DateTime - the date when the vehicle was acquired
/// - user: User - the user that owns the vehicle
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
