import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _login = 'login';



  static Future<bool> clearPreference(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getString(key);
    return preferences.remove(key);
  }

  static Future<bool> clearAllPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getString(_login);
    return preferences.clear();
  }


  static Future<bool> setDoLogin(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_login, value);
  }

  static Future<String> getDoLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_login) ?? '';
  }


}
