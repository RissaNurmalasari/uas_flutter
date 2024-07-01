import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _keyName = 'nama';
  static const String _keyEmail = 'email';

  static Future<void> saveUserData(
      String nama, String username, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, nama);
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }
}
