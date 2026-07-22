import 'package:dartz/dartz.dart';
import 'package:core_network/core_network.dart';
import '../entities/user.dart';

/// العقد البرمجي (Contract) لعمليات المصادقة والذي يجب على طبقة الـ Data تنفيذه.
abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
}
