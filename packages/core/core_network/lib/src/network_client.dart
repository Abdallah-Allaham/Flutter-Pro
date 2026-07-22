import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'failures.dart';

/// واجهة برمجية موحدة لجميع اتصالات الشبكة في التطبيق.
abstract class NetworkClient {
  Future<Either<Failure, Response<T>>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Either<Failure, Response<T>>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Either<Failure, Response<T>>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Either<Failure, Response<T>>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}

/// التنفيذ الفعلي لـ [NetworkClient] باستخدام مكتبة [Dio].
class DioNetworkClient implements NetworkClient {
  final Dio _dio;

  DioNetworkClient(this._dio);

  @override
  Future<Either<Failure, Response<T>>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _execute(() => _dio.get<T>(path, queryParameters: queryParameters, options: options));
  }

  @override
  Future<Either<Failure, Response<T>>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _execute(() => _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options));
  }

  @override
  Future<Either<Failure, Response<T>>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _execute(() => _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options));
  }

  @override
  Future<Either<Failure, Response<T>>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _execute(() => _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options));
  }

  /// دالة تغليف وتنفيذ طلبات الشبكة للتحكم في الأخطاء وتحويلها لـ [Failure]
  Future<Either<Failure, Response<T>>> _execute<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: $e'));
    }
  }

  /// دالة تصنيف أخطاء مكتبة [Dio]
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('انتهت مهلة الاتصال بالخادم، يرجى المحاولة لاحقاً.');
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final message = (error.response?.data?['message'] ?? 'فشل الاتصال بالخادم').toString();
        if (status == 401) {
          return const AuthFailure('انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً.');
        }
        return ServerFailure(message, statusCode: status);
      case DioExceptionType.cancel:
        return const ServerFailure('تم إلغاء الطلب.');
      case DioExceptionType.connectionError:
        return const NetworkFailure('لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.');
      default:
        return const ServerFailure('عذراً، حدث خطأ ما أثناء الاتصال بالخادم.');
    }
  }
}
