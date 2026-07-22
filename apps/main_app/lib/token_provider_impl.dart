import 'package:core_network/core_network.dart';
import 'package:core_storage/core_storage.dart';

/// تطبيق واجهة [TokenProvider] المطلوبة في حزمة الشبكة لتوفير الـ Token.
/// نعتمد على [SecureStorage] الموفرة من حزمة التخزين لقراءته وكتابته بأمان.
class TokenProviderImpl implements TokenProvider {
  final SecureStorage _secureStorage;

  TokenProviderImpl(this._secureStorage);

  @override
  Future<String?> getAccessToken() async {
    return _secureStorage.read('access_token');
  }

  @override
  Future<void> clearToken() async {
    await _secureStorage.delete('access_token');
  }
}
