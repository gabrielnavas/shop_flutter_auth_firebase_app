import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<bool> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<bool> saveMap(String key, Map<String, dynamic> value) {
    return saveString(key, jsonEncode(value));
  }

  static Future<String> getString(String key,
      [String defaultValue = '']) async {
    final prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(key);
    return value ?? defaultValue;
  }

  static Future<Map<dynamic, dynamic>?> getMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(key);
    if (value == null) {
      return null;
    }
    return jsonDecode(value);
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
