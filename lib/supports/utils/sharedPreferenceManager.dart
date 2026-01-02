import 'package:shared_preferences/shared_preferences.dart';

class  SharedPreferenceManager{
  static const String isWalkthroughShown = "isWalkthroughShown";
  static const String username = "username";
  static const String password = "password";
  static const String isFingerprintEnroll = "isFingerprintEnroll";

  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static setUsername(String name) async {
    (await prefs).setString(username, name);

  }

  static Future<String?> getUsername() async {
    return (await prefs).getString(username) ?? '';

  }

  static setPassword(String pass) async {
    (await prefs).setString(password, pass);

  }

  static Future<String?> getPassword() async {
    return (await prefs).getString(password) ?? '';

  }

  static setFingerPrintFirstView(bool status) async {
    (await prefs).setBool(isFingerprintEnroll, status);
  }

  static getFingerPrintFirstView() async {
    return (await prefs).getBool(isFingerprintEnroll) ?? false;
  }


  static setWalkthroughShown(bool status) async {
    (await prefs).setBool(isWalkthroughShown, status);
  }

  static getWalkthroughShown() async {
    return (await prefs).getBool(isWalkthroughShown) ?? false;
  }
  static Future<void> clearToken() async {
    (await prefs).remove(username);
    (await prefs).remove(password);
  }
}