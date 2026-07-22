import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network_client.dart';
import '../interceptors/auth_interceptor.dart';

/// تهيئة حزمة الشبكة وتسجيل الـ Dependencies الخاصة بها في GetIt.
/// نقوم بتمرير الـ [tokenProvider] المستقل ليتم استخدامه في الـ Interceptor.
void initNetworkModule(GetIt getIt, TokenProvider tokenProvider, {required String baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // إضافة إنترسيبتور المصادقة التلقائي لـ Dio
  dio.interceptors.add(AuthInterceptor(tokenProvider));

  // تسجيل Dio والـ NetworkClient كـ Singletons
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<NetworkClient>(() => DioNetworkClient(getIt<Dio>()));
}
