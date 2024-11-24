import 'package:farming_assistant/models/user.dart';

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
