import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class SharedPreferencesService {

  late SharedPreferences sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> getSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> setValue(String key, dynamic value, {bool print = true}) async {
    if (value == null) {
      if (print) log('$key - value is null');
      return Future.value(false);
    }
    if (print) log('${value.runtimeType} - $key - $value');

    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    }  else {
      throw ArgumentError(
          'Invalid value ${value.runtimeType} - Must be a String, int, bool, double, Map<String, dynamic> or StringList');
    }
  }

  bool getBoolAsync(String key, {bool defaultValue = false}) {
    return sharedPreferences.getBool(key) ?? defaultValue;
  }

  double getDoubleAsync(String key, {double defaultValue = 0.0}) {
    return sharedPreferences.getDouble(key) ?? defaultValue;
  }

  int getIntAsync(String key, {int defaultValue = 0}) {
    return sharedPreferences.getInt(key) ?? defaultValue;
  }

  String getStringAsync(String key, {String defaultValue = ''}) {
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  Future<bool> clearSharedPref() async {
    return await sharedPreferences.clear();
  }

}