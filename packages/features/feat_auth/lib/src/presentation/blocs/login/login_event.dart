import 'package:flutter/foundation.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

/// حدث طلب تسجيل الدخول مع البريد الإلكتروني وكلمة المرور.
class ExecuteLoginEvent extends LoginEvent {
  final String email;
  final String password;

  const ExecuteLoginEvent({
    required this.email,
    required this.password,
  });
}
