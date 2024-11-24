import 'package:farming_assistant/models/user.dart';

class Yield{
  String id;
  String name;
  String description;
  double quantity;
  User user;

  Yield(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(Map <String, dynamic> jsonData) {
    return Yield(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }

  static toJson(Yield yield) {
    return {
      'id': yield.id,
      'name': yield.name,
      'description': yield.description,
      'quantity': yield.quantity,
      'user': User.toJson(yield.user),
    };
  }
}
