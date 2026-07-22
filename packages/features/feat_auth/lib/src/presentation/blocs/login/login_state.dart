import 'package:flutter/foundation.dart';
import '../../../domain/entities/user.dart';

@immutable
abstract class LoginState {
  const LoginState();
}

/// الحالة المبدئية للواجهة
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// حالة جاري الاتصال وجلب البيانات (تحميل)
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// حالة نجاح تسجيل الدخول وتمرير بيانات المستخدم بنجاح
class LoginSuccess extends LoginState {
  final User user;
  const LoginSuccess(this.user);
}

/// حالة حدوث خطأ أثناء تسجيل الدخول وتمرير رسالة الخطأ المناسبة للـ UI
class LoginError extends LoginState {
  final String errorMessage;
  const LoginError(this.errorMessage);
}
