import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core_ui/core_ui.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';

/// صفحة تسجيل الدخول الرئيسية ذات المظهر العصري الفاخر (Premium Dark Mode Look).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(
            ExecuteLoginEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.darkGradient, // خلفية داكنة فخمة متدرجة
        ),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('مرحباً بك، ${state.user.name}! تم تسجيل الدخول بنجاح.'),
                  backgroundColor: AppColors.success,
                ),
              );
              // هنا ننتقل لصفحة الرئيسية (Home Page)
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is LoginLoading;

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // أيقونة الشعار مع تدرج لوني
                        Center(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                            ),
                            child: const Icon(
                              Icons.lock_open_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // نصوص الترحيب
                        Text(
                          'مرحباً بك مجدداً',
                          style: AppTextStyles.h1.copyWith(color: AppColors.textPrimaryDark),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'سجل دخولك للمتابعة والوصول إلى لوحة التحكم',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // حقل البريد الإلكتروني
                        CustomTextField(
                          label: 'البريد الإلكتروني',
                          hint: 'example@domain.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryLight),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'البريد الإلكتروني غير صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // حقل كلمة المرور
                        CustomTextField(
                          label: 'كلمة المرور',
                          hint: '••••••••',
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryLight),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور يجب ألا تقل عن 6 أحرف';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        // زر الدخول
                        PrimaryButton(
                          text: 'تسجيل الدخول',
                          isLoading: isLoading,
                          onPressed: () => _onLoginPressed(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
