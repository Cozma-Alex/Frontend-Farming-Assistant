import 'package:farming_assistant/models/user.dart';

/// Food model
/// Contains the following fields:
/// - id: UUID - the id of the food item (primary key)
/// - name: String - the name of the food item
/// - description: String - the description of the food item (optional)
/// - quantity: double - the quantity of the food item
/// - user: User - the user that owns the food item
class Food {
  String id;
  String name;
  String description;
  double quantity;
  User user;

  Food(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(Map<String, dynamic> jsonData) {
    return Food(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }

  static toJson(Food food) {
    return {
      'id': food.id,
      'name': food.name,
      'description': food.description,
      'quantity': food.quantity,
      'user': User.toJson(food.user),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Food && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
