import 'package:farming_assistant/models/user.dart';

/// Fertilizer model
/// This class is used to create a Fertilizer object having the following attributes:
/// - id: UUID - the id of the fertilizer (primary key)
/// - name: String - the name of the fertilizer (max 150 characters)
/// - description: String - the description of the fertilizer (optional - max 255 characters)
/// - quantity: double - the quantity of the fertilizer
/// - user: User - the user that owns the fertilizer (foreign key)
class Fertilizer{

  String id;
  String name;
  String description;
  double quantity;
  User user;

  Fertilizer(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(Map <String, dynamic> jsonData) {
    return Fertilizer(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }

  static toJson(Fertilizer fertilizer) {
    return {
      'id': fertilizer.id,
      'name': fertilizer.name,
      'description': fertilizer.description,
      'quantity': fertilizer.quantity,
      'user': User.toJson(fertilizer.user),
    };
  }
}
