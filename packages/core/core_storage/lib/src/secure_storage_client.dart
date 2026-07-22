import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// واجهة للتخزين المشفر للبيانات الحساسة.
abstract class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clearAll();
}

/// التنفيذ العملي باستخدام [FlutterSecureStorage] مع خيارات الأمان الأساسية لنظامي iOS و Android.
class SecureStorageClient implements SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorageClient(this._storage);

  @override
  Future<void> write(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: const AndroidOptions(encryptedSharedPreferences: true), // تشفير تلقائي بالهاردوير للأندرويد
      iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock), // حماية الـ Keychain لـ iOS
    );
  }

  @override
  Future<String?> read(String key) async {
    return _storage.read(
      key: key,
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(
      key: key,
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll(
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
  }
}
