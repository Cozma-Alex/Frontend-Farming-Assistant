import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

class User {
  String id;
  String email;
  String password;
  String farmName;
  String name;
  Uint8List imageData;

  User(this.id, this.email, this.password, this.farmName, this.name, this.imageData);

  static fromJson(jsonData) {
    return User(
      jsonData['id'],
      jsonData['email'],
      jsonData['password_hash'],
      jsonData['farm_name'],
      jsonData['name'],
      jsonData['image_data'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password, farmName: $farmName, name: $name}';
  }
}
