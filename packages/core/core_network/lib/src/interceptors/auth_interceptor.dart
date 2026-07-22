import 'package:dio/dio.dart';

/// واجهة برمجية مجردة لجلب توكن المصادقة لتجنب الاعتماد المباشر على التخزين
abstract class TokenProvider {
  Future<String?> getAccessToken();
  Future<void> clearToken();
}

/// إنترسيبتور مخصص لإضافة رأس المصادقة (Authorization Header) تلقائياً لكل طلب شبكة
class AuthInterceptor extends Interceptor {
  final TokenProvider _tokenProvider;

  AuthInterceptor(this._tokenProvider);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // يمكنك إضافة ترويسات أخرى مشتركة هنا (مثل Language أو Content-Type)
    options.headers['Accept'] = 'application/json';
    
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // هنا يمكن إرسال حدث لتسجيل الخروج التلقائي أو تجديد التوكن (Token Refresh)
      _tokenProvider.clearToken();
    }
    super.onError(err, handler);
  }
}
