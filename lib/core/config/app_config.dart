import 'package:book_market/core/config/app_flavor.dart';

class AppConfig {
  // Named private constructors still require the class name in Dart.
  // ignore: unnecessary_type_name_in_constructor
  const AppConfig._({
    required this.flavor,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableNetworkLogs,
    required this.useFakeData,
  });

  factory fromFlavor(AppFlavor flavor) {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    const connectTimeoutMs = int.fromEnvironment(
      'CONNECT_TIMEOUT_MS',
      defaultValue: 15000,
    );
    const receiveTimeoutMs = int.fromEnvironment(
      'RECEIVE_TIMEOUT_MS',
      defaultValue: 15000,
    );
    const configuredNetworkLogs = bool.fromEnvironment(
      'ENABLE_NETWORK_LOGS',
      defaultValue: true,
    );
    const configuredFakeData = String.fromEnvironment('USE_FAKE_DATA');

    final fallbackUrl = switch (flavor) {
      AppFlavor.development => 'http://10.0.2.2:8080/api/v1',
      AppFlavor.staging => '',
      AppFlavor.production => '',
    };

    return AppConfig.fromValues(
      flavor: flavor,
      apiBaseUrl: configuredUrl.isEmpty ? fallbackUrl : configuredUrl,
      connectTimeoutMs: connectTimeoutMs,
      receiveTimeoutMs: receiveTimeoutMs,
      enableNetworkLogs: configuredNetworkLogs,
      useFakeData: configuredFakeData.isEmpty
          ? flavor == AppFlavor.development
          : configuredFakeData.toLowerCase() == 'true',
    );
  }

  factory fromValues({
    required AppFlavor flavor,
    required String apiBaseUrl,
    required int connectTimeoutMs,
    required int receiveTimeoutMs,
    required bool enableNetworkLogs,
    required bool useFakeData,
  }) {
    if (flavor.isProduction && useFakeData) {
      throw StateError('USE_FAKE_DATA cannot be enabled in Production.');
    }

    final apiUrl = apiBaseUrl;
    if (apiUrl.isEmpty) {
      throw StateError(
        'API_BASE_URL is required for ${flavor.label}. '
        'Pass it with --dart-define or --dart-define-from-file.',
      );
    }
    final parsedApiUrl = Uri.tryParse(apiUrl);
    if (parsedApiUrl == null ||
        !parsedApiUrl.hasScheme ||
        !parsedApiUrl.hasAuthority ||
        (!flavor.isProduction &&
            parsedApiUrl.scheme != 'http' &&
            parsedApiUrl.scheme != 'https') ||
        (flavor.isProduction && parsedApiUrl.scheme != 'https')) {
      throw StateError('API_BASE_URL is not a valid URL for ${flavor.label}.');
    }

    return AppConfig._(
      flavor: flavor,
      apiBaseUrl: parsedApiUrl,
      connectTimeout: Duration(milliseconds: connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: receiveTimeoutMs),
      enableNetworkLogs: !flavor.isProduction && enableNetworkLogs,
      useFakeData: useFakeData,
    );
  }

  final AppFlavor flavor;
  final Uri apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableNetworkLogs;
  final bool useFakeData;
}
