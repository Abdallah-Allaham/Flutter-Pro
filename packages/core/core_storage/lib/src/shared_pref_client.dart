import 'package:shared_preferences/shared_preferences.dart';

/// واجهة للتخزين السريع للقيم البسيطة غير الحساسة (مثل وضع التطبيق، الإعدادات).
abstract class LocalStorage {
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);
  Future<bool> setInt(String key, int value);
  int? getInt(String key);
  Future<bool> remove(String key);
  Future<bool> clearAll();
}

/// التنفيذ العملي باستخدام [SharedPreferences].
class SharedPrefClient implements LocalStorage {
  final SharedPreferences _prefs;

  SharedPrefClient(this._prefs);

  @override
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  @override
  Future<bool> clearAll() async {
    return _prefs.clear();
  }
}
