import 'package:creativesapp/core/api/configuratio_api.dart';
import 'package:creativesapp/core/api/login_api.dart';
import 'package:creativesapp/core/api/user_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/Configuration.dart';
import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/services/authentication_service.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../locator.dart';
import 'base_model.dart';

class LoginModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  UserApi _userApi = locator<UserApi>();
  LoginApi _loginApi = locator<LoginApi>();
  ConfigurationApi _configurationApi =locator<ConfigurationApi>();

  List<Configuration> configurations ;

  String facLink,whatsAppNum , youtubeLink, instagramLink;


  User _user = new User();
  int _id;
  bool _logged_in = false;

  bool get isLoggedIn => _logged_in;

  void setLoggedIn(bool logged) {
    _logged_in = logged;
    notifyListeners();
  }

  Future<String> login(data) async {
    setState(ViewState.Busy);
    var res = await _loginApi.login(data);
    setState(ViewState.Idle);
    return res;
  }

  void LoggedIn() async {
    setState(ViewState.Busy);
    bool success = await _authenticationService.LoggedIn();
    setLoggedIn(success);
    setState(ViewState.Idle);
  }

  get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<User> getUser() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    _id = user.getInt(Constants.PREF_ID);

    if (_id != null) {
      setState(ViewState.Busy);
      User res = await _userApi.getUser(_id);
      setUser(res);
      setState(ViewState.Idle);
      return res;
    }
    return null;
  }

  Future getConfigurations() async {
    setState(ViewState.Busy);
    configurations= await _configurationApi.getConfigurations();


    for (var x in configurations) {
      print(x.key);
            if(x.key == 'FacebookPage'){
        facLink = x.value;

      }else if(x.key == 'YoutubeChannel'){
        youtubeLink = x.value;
      }else if(x.key == 'WahtsappNumber'){
          whatsAppNum = x.value;
      }else if(x.key == 'InstagramAccount'){
        instagramLink = x.value;
      }
    }

    setState(ViewState.Idle);
  }



}
