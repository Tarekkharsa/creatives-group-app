import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static PrefHelper _instance;

  SharedPreferences _pref;

  PrefHelper._();

  static Future<PrefHelper> getInstance() async {
    if (_instance == null) {
      _instance = PrefHelper._();
      _instance._pref = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  int getInt(String key) {
    return _pref.getInt(key) ?? -1;
  }

  void setInt(String key, int value) {
    _pref.setInt(key, value);
  }


  String getString(String key) {
    return _pref.getString(key) ?? null;
  }

  void setString(String key, String value) {
    _pref.setString(key, value);
  }

  bool contains(String key) {
    return _pref.containsKey(key);
  }

  void remove(String key) {
    _pref.remove(key);
  }
}