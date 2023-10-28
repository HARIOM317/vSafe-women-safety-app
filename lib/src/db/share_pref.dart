import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsafe/src/chat/apis.dart';

SharedPreferences? _preferences;
const String key = 'user_type';

logoutUser() async{
  await APIs.updateActiveStatus(false);
  _preferences = await SharedPreferences.getInstance();
  _preferences?.remove('user_type');
}

class MySharedPreference {
  static init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future saveUserType(String type) async {
    return await _preferences!.setString(key, type);
  }

  static Future<String>? getUserType() async =>
      _preferences!.getString(key) ?? "";
}
