import 'package:dartz/dartz.dart';
import 'package:core_network/core_network.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// حالة استخدام (UseCase) واحدة ومستقلة لتسجيل الدخول.
@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    // يمكن هنا إضافة شروط التحقق من البيانات (Business Logic Verification) قبل استدعاء المستودع
    if (email.isEmpty || !email.contains('@')) {
      return const Left(ServerFailure('يرجى إدخال بريد إلكتروني صالح.'));
    }
    return _repository.login(email: email, password: password);
  }
}
