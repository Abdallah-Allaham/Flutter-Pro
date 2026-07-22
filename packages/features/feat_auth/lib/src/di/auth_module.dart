import 'package:get_it/get_it.dart';
import 'package:core_network/core_network.dart';
import 'package:core_storage/core_storage.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../presentation/blocs/login/login_bloc.dart';

/// تهيئة حزمة ميزة المصادقة وتسجيل تبعياتها.
void initAuthModule(GetIt getIt) {
  // 1. Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<NetworkClient>()),
  );

  // 2. Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>(), getIt<SecureStorage>()),
  );

  // 3. Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  // 4. Blocs (يتم تسجيلها كـ Factory لتوليد نسخة جديدة في كل مرة تفتح فيها الصفحة)
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(getIt<LoginUseCase>()),
  );
}
