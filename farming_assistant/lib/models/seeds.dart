import 'package:farming_assistant/models/user.dart';

/// Seeds model
/// Represents a seed in the database with the following fields:
/// - id: UUID - unique identifier of the seed (primary key)
/// - name: String - name of the seed (e.g. Tomato)
/// - description: String - description of the seed (e.g. type, color)
/// - quantity: double - quantity of the seed (e.g. 0.5 kg)
/// - user: User - user that owns the seed (foreign key)
class Seeds{
  String id;
  String name;
  String description;
  double quantity;
  User user;

  Seeds(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(Map <String, dynamic> jsonData) {
    return Seeds(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }

  static toJson(Seeds seeds) {
    return {
      'id': seeds.id,
      'name': seeds.name,
      'description': seeds.description,
      'quantity': seeds.quantity,
      'user': User.toJson(seeds.user),
    };
  }
}
