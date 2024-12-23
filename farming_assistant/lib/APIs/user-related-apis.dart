import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/config.dart';

Future<User> loginAPI(User user) async {
  final uri = Uri.parse('${APIConfig.baseURI}/users/auth');

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': user.email,
        'password_hash': user.password,
      }),
    );

    return User.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}

Future<User> registerAPI(User user) async {
  final uri = Uri.parse('${APIConfig.baseURI}/users');

  try {
    final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(User.toJson(user)));

    return User.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to register: $e');
  }
}
