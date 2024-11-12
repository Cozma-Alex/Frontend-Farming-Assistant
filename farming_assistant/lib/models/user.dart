class User {
  String id;
  String email;
  String password;

  User(this.id, this.email, this.password);

  static fromJson(jsonData) {
    return User(
        jsonData['id'], jsonData['email'], jsonData['password_hash']);
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password}';
  }
}
