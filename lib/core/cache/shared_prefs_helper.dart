import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/data.export.dart';
import '../utils/utils.export.dart';

class SharedPrefsClient {
  final SharedPreferences _prefs;
  SharedPrefsClient(this._prefs);

  // set a string in prefs
  void setString(String key, String data) async =>
      await _prefs.setString(key, data);

  String? getString(String key) => _prefs.getString(key);

  // save user token
  void saveUserToken(String userToken) async =>
      await _prefs.setString(kUserAccessTokenKey, userToken);

  // clear user related data
  void clearUserData() async {
    await _prefs.remove(kUserAccessTokenKey);
    await _prefs.remove(kUserDataKey);
  }

  String? get getUserData => _prefs.getString(kUserDataKey);

  String? get getCachedUserToken => _prefs.getString(kUserAccessTokenKey);

  void cacheUserData(UserModel user) async =>
      await _prefs.setString(kUserDataKey, json.encode(user.toJson()));

  void remove(String key) async => await _prefs.remove(key);
}
