import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static String token = '';
  final STORAGE_KEY = 'token';

  /**
   * 利用SharedPreferences存储数据
   */
  Future<String> setString(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(STORAGE_KEY, token);
    return token;
  }

  /**
   * 获取存在SharedPreferences中的数据
   */
  Future<String> getString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString(STORAGE_KEY);
    return token;
  }
}