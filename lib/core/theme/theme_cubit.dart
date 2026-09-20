import 'package:bloc/bloc.dart';
import 'package:book_market/core/storage/preferences_storage.dart';

enum AppThemeMode { system, light, dark }

final class ThemeCubit extends Cubit<AppThemeMode> {
  new(this._storage) : super(_parse(_storage.readThemeMode()));

  final PreferencesStorage _storage;

  Future<void> setThemeMode(AppThemeMode mode) async {
    emit(mode);
    await _storage.writeThemeMode(mode.name);
  }

  static AppThemeMode _parse(String? value) => AppThemeMode.values.firstWhere(
    (mode) => mode.name == value,
    orElse: () => AppThemeMode.system,
  );
}
