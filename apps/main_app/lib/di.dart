import 'package:get_it/get_it.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_network/core_network.dart';
import 'package:feat_auth/feat_auth.dart';
import 'token_provider_impl.dart';

final getIt = GetIt.instance;

/// دالة التهيئة المركزية لجميع الخدمات والحزم قبل تشغيل التطبيق.
Future<void> setupInjection() async {
  // 1. تهيئة SharedPreferences المشترك
  final sharedPreferences = await SharedPreferences.getInstance();

  // 2. تهيئة حزمة التخزين المشترك
  initStorageModule(getIt, sharedPreferences);

  // 3. إنشاء كائن الـ TokenProvider وربطه بحزمة الشبكة
  final tokenProvider = TokenProviderImpl(getIt<SecureStorage>());

  // 4. تهيئة حزمة الشبكة بالـ base URL الخاص بالسيرفر
  initNetworkModule(
    getIt,
    tokenProvider,
    baseUrl: 'https://api.example.com',
  );

  // 5. تهيئة حزم الميزات (Features Modules)
  initAuthModule(getIt);
}
