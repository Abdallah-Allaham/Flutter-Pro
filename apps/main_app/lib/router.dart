import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feat_auth/feat_auth.dart';
import 'di.dart';

/// إعداد المسارات والتنقل باستخدام [GoRouter].
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        // نطبق القانون البرمجي: لف الصفحة بالـ BlocProvider الخاص بها
        // وجلب الـ Bloc من الـ Service Locator (GetIt) لضمان عزل الحالة محلياً.
        return BlocProvider<LoginBloc>(
          create: (context) => getIt<LoginBloc>(),
          child: const LoginPage(),
        );
      },
    ),
    // يمكنك إضافة مسارات متداخلة (Nested Routes) أو صفحة رئيسية هنا لاحقاً
  ],
);
