import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/services/pref_helper.dart';
import 'package:creativesapp/core/utils/Constants.dart';

class UserManager {
  User _user;

  UserManager() {
    _user = User();

    _init();
  }

  User get user => _user;

  void login(User user) {
    //Save user
    PrefHelper.getInstance()
        .then((instance) => instance.setString(Constants.PREF_NAME, user.name));
    PrefHelper.getInstance()
        .then((instance) => instance.setString(Constants.PREF_IMAGE, user.image));
    PrefHelper.getInstance()
        .then((instance) => instance.setInt(Constants.PREF_ID, user.id));
    PrefHelper.getInstance().then(
        (instance) => instance.setString(Constants.PREF_TOKEN, user.token));

    _user = user;
  }



  bool isLoggedIn() {
    return user != null && user.token != null;
  }

  void logout() {
    //Remove user
    PrefHelper.getInstance()
        .then((instance) => instance.remove(Constants.PREF_NAME));
    PrefHelper.getInstance()
        .then((instance) => instance.remove(Constants.PREF_IMAGE));
    PrefHelper.getInstance()
        .then((instance) => instance.remove(Constants.PREF_ID));
    PrefHelper.getInstance()
        .then((instance) => instance.remove(Constants.PREF_TOKEN));

    _user = User();
    return;
  }

  void _init() async {
    await PrefHelper.getInstance().then(
        (instance) => _user.name = instance.getString(Constants.PREF_NAME));
    await PrefHelper.getInstance().then(
            (instance) => _user.image = instance.getString(Constants.PREF_IMAGE));
    await PrefHelper.getInstance()
        .then((instance) => _user.id = instance.getInt(Constants.PREF_ID));
    await PrefHelper.getInstance().then(
        (instance) => _user.token = instance.getString(Constants.PREF_TOKEN));
  }
}
