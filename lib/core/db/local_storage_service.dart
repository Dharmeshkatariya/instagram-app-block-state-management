import '../../export.dart';

class LocalStorage {
  static const String keyLoggedIn = 'isLoggedIn';
  static const String token = 'token';
  static const String firstLaunch = 'firstLaunch';
  static const String userProfile = 'userProfile';
}

class LSProvider {
  LSProvider._();

  static Future<void> setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LocalStorage.token);
  }

  static Future<void> removeKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<bool?> removeSharedPre() async {
    var prefs = await SharedPreferences.getInstance();
    return await prefs.remove(LocalStorage.keyLoggedIn);
  }
}
