import 'dart:convert';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class SharedPreference {
  static Future<void> setUserData(UserModel userModel) async {
    Map<String, dynamic> userMap = userModel.toJson();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserData', jsonEncode(userMap));
  }

  static Future<void> setRememberData(
      {required String userName, required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppText.userName, userName);
    prefs.setString(AppText.password, password);
  }

  static Future<void> saveUserNameandPassword(
      {required String userName, required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('${AppText.userName}saved', userName);
    prefs.setString('${AppText.password}saved', password);
  }

  static Future<UserModel?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('UserData');
    if (userString == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userString);
    UserModel userModel = UserModel.fromJson(userMap);
    return userModel;
  }

  static Future<bool> logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var d = await prefs.clear();
    print(d);
    return true;
  }
}
