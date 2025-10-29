import 'package:flutter_test/flutter_test.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module_impl.dart';
import 'package:hot_tourist_destinations/modules/auth/services/local_auth_client.dart';

import '../../../testing/fakes/sqlite.dart' as sqlite;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late String createDbScript;
  late LocalAuthClient apiClient;
  late AuthModule authModule;

  setUpAll(() async {
    createDbScript = await sqlite.dbScript;
  });

  setUp(() async {
    // Create a fresh database for each test to avoid state pollution
    var db = sqlite.inMemoryClient(createDbScript);
    await db.open();
    apiClient = LocalAuthClient(sqliteClient: db);
    authModule = AuthModuleImpl(apiClient: apiClient);
  });

  group('AuthModule Requirements', () {
    /**
     * Requirements based on AuthModule contract:
     *
     * 1. register() should:
     *    - Create a new user account with name, email, and password
     *    - Return ProfileDto on success
     *    - Update profileNotifier with user profile
     *    - Return Exception on failure
     *
     * 2. login() should:
     *    - Authenticate user with email and password
     *    - Return ProfileDto on success
     *    - Update profileNotifier with user profile
     *    - Return IncorrectLoginCredentialsException for wrong credentials
     *    - Return Exception on other failures
     *
     * 3. getProfile() should:
     *    - Return null when no user is authenticated
     *    - Return ProfileDto when user is authenticated
     *
     * 4. logout() should:
     *    - Clear profileNotifier
     *    - Work even when no user is logged in
     *    - Return Exception on failure
     */

    group('register()', () {
      test('should create a new user and return ProfileDto', () async {
        // Arrange
        const name = 'John Doe';
        const email = 'john@example.com';
        const password = 'password123';

        // Act
        final (:success, :error) = (await authModule.register(
          name,
          email,
          password,
        )).getBoth();

        // Assert
        expect(error, isNull);
        expect(success, isNotNull);
        expect(success!.name, equals(name));
        expect(success.email, equals(email));
        expect(success.id, isNotNull);
      });

      test(
        'should update profileNotifier on successful registration',
        () async {
          // Arrange
          const name = 'Jane Doe';
          const email = 'jane@example.com';
          const password = 'password123';

          // Act
          await authModule.register(name, email, password);
          final profile = authModule.profileNotifier.value;

          // Assert
          expect(profile, isNotNull);
          expect(profile!.name, equals(name));
          expect(profile.email, equals(email));
        },
      );

      test('should return error when registration fails', () async {
        // Arrange - Register first user
        const email = 'duplicate@example.com';
        await authModule.register('First User', email, 'password123');

        // Act - Try to register with same email
        final (:success, :error) = (await authModule.register(
          'Second User',
          email,
          'password123',
        )).getBoth();

        // Assert
        expect(error, isNotNull);
      });
    });

    group('login()', () {
      test(
        'should authenticate user and return ProfileDto on correct credentials',
        () async {
          // Arrange
          const name = 'Test User';
          const email = 'test@example.com';
          const password = 'password123';
          await authModule.register(name, email, password);
          await authModule.logout(); // Clear token

          // Act
          final (:success, :error) = (await authModule.login(
            email,
            password,
          )).getBoth();

          // Assert
          expect(error, isNull);
          expect(success, isNotNull);
          expect(success!.name, equals(name));
          expect(success.email, equals(email));
        },
      );

      test('should update profileNotifier on successful login', () async {
        // Arrange
        const email = 'logintest@example.com';
        const password = 'password123';
        await authModule.register('Login Test', email, password);
        await authModule.logout();

        // Act
        final (:success, :error) = (await authModule.login(
          email,
          password,
        )).getBoth();

        // Assert
        expect(error, isNull);
        final profile = authModule.profileNotifier.value;
        expect(profile, isNotNull);
        expect(profile!.email, equals(email));
      });

      test(
        'should return IncorrectLoginCredentialsException for wrong password',
        () async {
          // Arrange
          const email = 'wrongpass@example.com';
          await authModule.register('User', email, 'correctpassword');
          await authModule.logout();

          // Act
          final (:success, :error) = (await authModule.login(
            email,
            'wrongpassword',
          )).getBoth();

          // Assert
          expect(success, isNull);
          expect(error, isA<IncorrectLoginCredentialsException>());
        },
      );

      test(
        'should return IncorrectLoginCredentialsException for non-existent user',
        () async {
          // Act
          final (:success, :error) = (await authModule.login(
            'nonexistent@example.com',
            'password',
          )).getBoth();

          // Assert
          expect(success, isNull);
          expect(error, isA<IncorrectLoginCredentialsException>());
        },
      );
    });

    group('getProfile()', () {
      test('should return null when no user is authenticated', () async {
        // Act
        final profile = authModule.getProfile();

        // Assert
        expect(profile, isNull);
      });

      test('should return ProfileDto when user is authenticated', () async {
        // Arrange
        const name = 'Authenticated User';
        const email = 'auth@example.com';
        const password = 'password123';
        await authModule.register(name, email, password);

        // Act
        final profile = authModule.getProfile();

        // Assert
        expect(profile, isNotNull);
        expect(profile!.name, equals(name));
        expect(profile.email, equals(email));
      });

      test('should return null after logout', () async {
        // Arrange
        await authModule.register('User', 'user@example.com', 'password123');
        await authModule.logout();

        // Act
        final profile = authModule.getProfile();

        // Assert
        expect(profile, isNull);
      });
    });

    group('logout()', () {
      test('should clear profileNotifier', () async {
        // Arrange
        await authModule.register('User', 'logout@example.com', 'password123');

        // Act
        final (:success, :error) = (await authModule.logout()).getBoth();

        // Assert
        expect(error, isNull);
        final profile = authModule.profileNotifier.value;
        expect(profile, isNull);
      });

      test('should succeed even when no user is logged in', () async {
        // Act
        final (:success, :error) = (await authModule.logout()).getBoth();

        // Assert
        expect(error, isNull);
      });

      test('should make getProfile return null after logout', () async {
        // Arrange
        await authModule.register('User', 'profile@example.com', 'password123');

        // Act
        await authModule.logout();
        final profile = authModule.getProfile();

        // Assert
        expect(profile, isNull);
      });
    });
  });
}
