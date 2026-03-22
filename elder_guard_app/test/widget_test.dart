import 'package:elder_guard_app/app/elder_guard_app.dart';
import 'package:elder_guard_app/core/di/core_providers.dart';
import 'package:elder_guard_app/features/auth/data/auth_repository.dart';
import 'package:elder_guard_app/features/auth/data/models/auth_session.dart';
import 'package:elder_guard_app/features/auth/data/models/register_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows auth screen and toggles language', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: const ElderGuardApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('VI'), findsOneWidget);

    await tester.tap(find.text('VI'));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    return AuthSession(accessToken: 'token', email: email);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<RegisterResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return const RegisterResult(message: 'User created', id: 1);
  }

  @override
  Future<AuthSession?> restoreSession() async => null;
}
