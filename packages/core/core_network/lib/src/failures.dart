/// كلاس الأخطاء الرئيسي المشترك لجميع العمليات في التطبيق.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// فشل ناتج عن خطأ من السيرفر (مثل 500 أو 404 أو تفاصيل خطأ الـ API)
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

/// فشل ناتج عن عدم وجود اتصال بالإنترنت (Offline)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// فشل ناتج عن خطأ في التخزين المؤقت المحلي (Cache Error)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// فشل ناتج عن عدم وجود صلاحيات (Unauthorized 401)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
