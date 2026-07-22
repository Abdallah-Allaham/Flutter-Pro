import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'di.dart';
import 'router.dart';

void main() async {
  // التأكد من تهيئة بيئة تشغيل Flutter قبل أي كود غير متزامن
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة حقن التبعيات بالترتيب الصحيح
  await setupInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Pro Boilerplate',
      debugShowCheckedModeBanner: false,
      
      // التوجيه
      routerConfig: appRouter,
      
      // السمات البصرية (Themes) مع دعم الوضع الداكن والفاتح
      themeMode: ThemeMode.dark, // الافتراضي هو الداكن لمظهر فاخر
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surfaceDark,
          error: AppColors.error,
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surfaceLight,
          error: AppColors.error,
        ),
      ),
    );
  }
}
