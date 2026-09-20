import 'package:book_market/app/app.dart';
import 'package:book_market/core/config/app_config.dart';
import 'package:book_market/core/config/app_flavor.dart';
import 'package:book_market/core/routing/app_router.dart';
import 'package:book_market/core/storage/preferences_storage.dart';
import 'package:book_market/core/theme/theme_cubit.dart';
import 'package:book_market/features/catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('App', () {
    testWidgets('renders CatalogPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        App(
          config: AppConfig.fromFlavor(AppFlavor.development),
          appRouter: AppRouter(
            const FakeCatalogRepository(delay: Duration.zero),
          ),
          themeCubit: ThemeCubit(PreferencesStorage(preferences)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CatalogPage), findsOneWidget);
    });
  });
}
