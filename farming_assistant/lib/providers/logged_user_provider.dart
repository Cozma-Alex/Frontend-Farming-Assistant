import 'package:flutter/material.dart';
import '../models/user.dart';

class LoggedUserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void logoutUser() {
    _user = null;
    notifyListeners();
  }
}
