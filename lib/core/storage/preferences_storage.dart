import 'package:shared_preferences/shared_preferences.dart';

final class PreferencesStorage {
  const new(this._preferences);

  static const _themeModeKey = 'theme_mode';
  final SharedPreferences _preferences;

  String? readThemeMode() => _preferences.getString(_themeModeKey);

  Future<bool> writeThemeMode(String value) =>
      _preferences.setString(_themeModeKey, value);
}
