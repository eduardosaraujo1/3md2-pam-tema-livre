import 'package:flutter_test/flutter_test.dart';
import 'package:hot_tourist_destinations/modules/auth/services/token_store.dart';

import '../../../testing/fakes/fake_flutter_secure_storage.dart';

void main() {
  late FakeFlutterSecureStorage mockSecureStorage;
  late TokenStore tokenStore;

  setUp(() {
    mockSecureStorage = FakeFlutterSecureStorage();
    tokenStore = TokenStore(secureStorage: mockSecureStorage);
  });

  test('stores and retrieves tokens', () async {
    const token = 'test_token';
    await tokenStore.saveToken(token);
    final retrievedToken = await tokenStore.loadToken();
    expect(retrievedToken, token);
  });

  test('clears token', () async {
    const token = 'test_token';

    await tokenStore.saveToken(token);
    await tokenStore.deleteToken();

    final retrievedToken = await tokenStore.loadToken();
    expect(retrievedToken, isNull);
  });
}
