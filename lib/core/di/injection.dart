import 'package:book_market/core/config/app_config.dart';
import 'package:book_market/core/network/api_client.dart';
import 'package:book_market/core/network/auth_interceptor.dart';
import 'package:book_market/core/network/safe_log_interceptor.dart';
import 'package:book_market/core/routing/app_router.dart';
import 'package:book_market/core/storage/preferences_storage.dart';
import 'package:book_market/core/storage/token_storage.dart';
import 'package:book_market/core/theme/theme_cubit.dart';
import 'package:book_market/features/catalog/catalog.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies(AppConfig config) async {
  await getIt.reset();
  getIt.registerSingleton<AppConfig>(config);

  const secureStorage = FlutterSecureStorage();
  getIt.registerLazySingleton<TokenStorage>(
    () => const SecureTokenStorage(secureStorage),
  );

  final preferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => PreferencesStorage(preferences));

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl.toString(),
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: const {'Accept': 'application/json'},
      ),
    )..interceptors.add(AuthInterceptor(getIt<TokenStorage>()));

    if (config.enableNetworkLogs) {
      dio.interceptors.add(SafeLogInterceptor());
    }
    return dio;
  });
  getIt.registerLazySingleton(() => ApiClient(getIt<Dio>()));
  getIt.registerLazySingleton<CatalogRemoteDataSource>(
    () => ApiCatalogRemoteDataSource(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<CatalogRepository>(
    () => config.useFakeData
        ? const FakeCatalogRepository()
        : CatalogRepositoryImpl(getIt<CatalogRemoteDataSource>()),
  );
  getIt
    ..registerLazySingleton(() => ThemeCubit(getIt<PreferencesStorage>()))
    ..registerLazySingleton(() => AppRouter(getIt<CatalogRepository>()));
}
