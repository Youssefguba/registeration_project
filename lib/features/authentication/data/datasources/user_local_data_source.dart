import 'dart:convert';

import '../../../../core/cache/cache.export.dart';
import '../../../../core/utils/utils.export.dart';
import '../data.export.dart';

abstract class UserLocalDataSource {
  void cacheUserData(UserModel user);

  void cacheUserToken(String userToken);

  void clearUserData();

  // Get Cached Access Token of User
  String? get getCachedUserToken;

  String? get getUserData;
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPrefsClient _prefs;

  UserLocalDataSourceImpl(this._prefs);

  @override
  void cacheUserData(UserModel user) {
    _prefs.setString(kUserDataKey, json.encode(user.toJson()));
  }

  @override
  void cacheUserToken(String userToken) =>
      _prefs.setString(kUserAccessTokenKey, userToken);

  @override
  String? get getUserData => _prefs.getString(kUserDataKey);

  @override
  String? get getCachedUserToken => _prefs.getString(kUserAccessTokenKey);

  // clear user related data
  @override
  void clearUserData() {
    _prefs.remove(kUserDataKey);
    _prefs.remove(kUserAccessTokenKey);
  }
}
