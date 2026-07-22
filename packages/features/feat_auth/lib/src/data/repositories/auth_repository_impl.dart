import 'package:dartz/dartz.dart';
import 'package:core_network/core_network.dart';
import 'package:core_storage/core_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// كلاس المستودع الفعلي المسؤول عن ربط وتسيير البيانات بين الـ DataSource والتطبيق.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(email: email, password: password);

    return result.fold(
      (failure) => Left(failure),
      (data) async {
        try {
          // جلب وتحويل البيانات المستلمة (JSON Mapping) لـ Entity المستخدم
          final userData = data['user'] as Map<String, dynamic>;
          final token = data['token'] as String;

          final user = User(
            id: userData['id'] as String,
            email: userData['email'] as String,
            name: userData['name'] as String,
            token: token,
          );

          // تخزين التوكن بشكل آمن ومحمي لاستخدامه لاحقاً في الترويسات (Headers)
          await _secureStorage.write('access_token', token);

          return Right(user);
        } catch (e) {
          return const Left(ServerFailure('فشل في تحليل بيانات المستخدم المستلمة من السيرفر.'));
        }
      },
    );
  }
}
