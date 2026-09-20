import 'package:book_market/core/config/app_config.dart';
import 'package:book_market/core/config/app_flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig', () {
    test('uses an Android-emulator URL for development by default', () {
      final config = AppConfig.fromFlavor(AppFlavor.development);

      expect(config.apiBaseUrl.host, '10.0.2.2');
      expect(config.enableNetworkLogs, isTrue);
    });

    test('fails fast when production API_BASE_URL is missing', () {
      expect(
        () => AppConfig.fromFlavor(AppFlavor.production),
        throwsA(isA<StateError>()),
      );
    });
  });
}
