import 'package:book_market/core/storage/preferences_storage.dart';
import 'package:book_market/core/storage/token_storage.dart';
import 'package:book_market/core/theme/theme_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SecureTokenStorage', () {
    late FlutterSecureStorage secureStorage;
    late SecureTokenStorage tokenStorage;

    setUp(() {
      secureStorage = _MockFlutterSecureStorage();
      tokenStorage = SecureTokenStorage(secureStorage);
    });

    test('reads and writes both token types', () async {
      when(() => secureStorage.read(key: 'access_token'))
          .thenAnswer((_) async => 'access');
      when(() => secureStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => 'refresh');
      when(
        () => secureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      expect(await tokenStorage.readAccessToken(), 'access');
      expect(await tokenStorage.readRefreshToken(), 'refresh');
      await tokenStorage.writeAccessToken('new-access');
      await tokenStorage.writeRefreshToken('new-refresh');

      verify(
        () => secureStorage.write(key: 'access_token', value: 'new-access'),
      ).called(1);
      verify(
        () => secureStorage.write(key: 'refresh_token', value: 'new-refresh'),
      ).called(1);
    });

    test('clears only auth-owned keys', () async {
      when(() => secureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await tokenStorage.clear();

      verify(() => secureStorage.delete(key: 'access_token')).called(1);
      verify(() => secureStorage.delete(key: 'refresh_token')).called(1);
      verifyNever(() => secureStorage.deleteAll());
    });
  });

  group('PreferencesStorage and ThemeCubit', () {
    test('persists and restores theme mode', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final storage = PreferencesStorage(preferences);
      final cubit = ThemeCubit(storage);

      expect(cubit.state, AppThemeMode.system);
      await cubit.setThemeMode(AppThemeMode.dark);

      expect(cubit.state, AppThemeMode.dark);
      expect(storage.readThemeMode(), 'dark');
      expect(ThemeCubit(storage).state, AppThemeMode.dark);
      await cubit.close();
    });
  });
}

final class _MockFlutterSecureStorage extends Mock
    implements FlutterSecureStorage;
