import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

/// كلاس الـ BLoC المسؤول عن ربط وتسيير الأحداث والحالات لواجهة تسجيل الدخول.
@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(const LoginInitial()) {
    // نستخدم transformer: droppable() للتأكد من تجاهل نقرات المستخدم المزدوجة المتتالية
    // طالما أن عملية تسجيل الدخول الأولى لم تنتهِ بعد.
    on<ExecuteLoginEvent>(
      _onExecuteLogin,
      transformer: droppable(),
    );
  }

  Future<void> _onExecuteLogin(
    ExecuteLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }
}
