import 'package:creativesapp/core/api/login_api.dart';
import 'package:creativesapp/core/api/user_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/services/authentication_service.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../locator.dart';
import 'base_model.dart';

class DrawerModel extends BaseModel {


  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();

  String _userName = null,_userImg = null;
  bool _logged_in = false;

  bool get isLoggedIn => _logged_in;



  void setLoggedIn( bool logged){
    _logged_in  = logged;
    notifyListeners();
  }



  void LoggedIn() async {
    setState(ViewState.Busy);
    bool success = await _authenticationService.LoggedIn();
    setLoggedIn(success);
    setState(ViewState.Idle);
  }






  get userName => _userName;

  void setUserName(String user) {
    _userName = user;
    notifyListeners();
  }

  void getUserName() async{
    SharedPreferences user = await SharedPreferences.getInstance();
    if(user != null){
      String name = user.getString(Constants.PREF_NAME);
      if(name != null){
        print(name);
        setUserName(name);
        print( "name :" +name);
      }
    }
  }

  get userImg => _userImg;

  void setUserImg(String img) {
    _userImg = img;
    notifyListeners();
  }

  void getUserImg() async{
    SharedPreferences user = await SharedPreferences.getInstance();
    if(user != null){
      String img = user.getString(Constants.PREF_IMAGE);
      if(img != null){

        setUserImg(img);
        print( "img :" +img);

      }
    }
  }




}
