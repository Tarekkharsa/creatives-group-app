import 'dart:async';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  Future<bool> LoggedIn() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    var token = user.get(Constants.PREF_TOKEN);
    if (token != null) {
      print('true');
      return true;
    }
    return false;
  }
}
