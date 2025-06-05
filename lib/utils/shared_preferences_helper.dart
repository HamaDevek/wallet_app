import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;
  static Future init({VoidCallback? callback}) async {
    _prefs = await SharedPreferences.getInstance();
    callback?.call();
  }

  static List getList(String key) {
    String? walletPref = _prefs.getString('pref_$key');
    if (walletPref != null) {
      return jsonDecode(walletPref);
    }
    return [];
  }

  static Map? getMap(String? key) {
    String? walletPref = _prefs.getString('pref_$key');
    if (walletPref != null) {
      return jsonDecode(walletPref);
    }
    return null;
  }

  static String? getString(String key) {
    return _prefs.getString('pref_$key');
  }

  static int? getInt(String key) {
    return _prefs.getInt('pref_$key');
  }

  static bool? getBool(String key) {
    return _prefs.getBool('pref_$key');
  }

  static double? getDouble(String key) {
    return _prefs.getDouble('pref_$key');
  }

  static Future<bool> save(dynamic data, String key) async {
    if (data is List || data is Map) {
      return await _prefs.setString('pref_$key', jsonEncode(data));
    }
    if (data is String) {
      return await _prefs.setString('pref_$key', data);
    }
    if (data is bool) {
      return await _prefs.setBool('pref_$key', data);
    }
    if (data is double) {
      return await _prefs.setDouble('pref_$key', data);
    }
    if (data is int) {
      return await _prefs.setInt('pref_$key', data);
    }
    return false;
  }

  static remove(String key) {
    _prefs.remove('pref_$key');
  }

  // Clear all data
  static clear() {
    _prefs.clear();
  }
}
