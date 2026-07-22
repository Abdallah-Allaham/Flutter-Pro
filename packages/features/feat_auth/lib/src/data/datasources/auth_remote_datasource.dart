import 'package:dartz/dartz.dart';
import 'package:core_network/core_network.dart';

/// واجهة مصدر البيانات البعيد للتعامل مع الـ API مباشرة.
abstract class AuthRemoteDataSource {
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });
}

/// التنفيذ الفعلي لمصدر البيانات البعيد باستخدام [NetworkClient] المشترك.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkClient _networkClient;

  AuthRemoteDataSourceImpl(this._networkClient);

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    final response = await _networkClient.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return response.fold(
      (failure) => Left(failure),
      (dioResponse) {
        if (dioResponse.data != null) {
          return Right(dioResponse.data!);
        }
        return const Left(ServerFailure('بيانات الاستجابة فارغة من السيرفر.'));
      },
    );
  }
}
