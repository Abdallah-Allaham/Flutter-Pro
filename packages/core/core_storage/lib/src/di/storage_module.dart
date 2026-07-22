import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../secure_storage_client.dart';
import '../shared_pref_client.dart';

/// تهيئة حزمة التخزين المحلي وتسجيل الـ Dependencies.
/// نتلقى الـ [sharedPreferences] المهيأ مسبقاً في الدالة لتجنب العمليات غير المتزامنة المعقدة أثناء التسجيل.
void initStorageModule(GetIt getIt, SharedPreferences sharedPreferences) {
  // تسجيل FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();
  getIt.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorageClient(getIt<FlutterSecureStorage>()));

  // تسجيل SharedPreferences
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<LocalStorage>(() => SharedPrefClient(getIt<SharedPreferences>()));
}
