// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../models/farm_element.dart';
//
// class StorageService {
//   static const String _keyFarmElements = 'farm_elements';
//
//   Future<void> saveElements(List<FarmElement> elements) async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = elements.map((e) => e.toJson()).toList();
//     await prefs.setString(_keyFarmElements, jsonEncode(data));
//   }
//
//   Future<List<FarmElement>> loadElements() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = prefs.getString(_keyFarmElements);
//     if (data == null) return [];
//
//     final List<dynamic> jsonList = jsonDecode(data);
//     return jsonList.map((json) => FarmElement.fromJson(json)).toList();
//   }
// }