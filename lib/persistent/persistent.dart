import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _sharedPreferences;

Future<SharedPreferences> get sharedPreferences async {
  _sharedPreferences ??= await SharedPreferences.getInstance();
  return _sharedPreferences!;
}

const tokenKey = "token";
String? token;
// set token
Future<void> setToken(String token) async {
  final prefs = await sharedPreferences;
  await prefs.setString(tokenKey, token);
}
// get token
Future<String?> getToken() async {
  final prefs = await sharedPreferences;
  return prefs.getString(tokenKey);
}
Future removeToken() async {
  final prefs = await sharedPreferences;
  await prefs.remove(tokenKey);
}
