import 'package:creativesapp/core/api/category_api.dart';
import 'package:creativesapp/core/api/coaches_api.dart';
import 'package:creativesapp/core/api/configuratio_api.dart';
import 'package:creativesapp/core/api/course_api.dart';
import 'package:creativesapp/core/api/user_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/category.dart';
import 'package:creativesapp/core/models/coach.dart';
import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/services/user_manager.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../locator.dart';
import 'base_model.dart';

class HomeModel extends BaseModel {
  CategoryApi _apiCategories = locator<CategoryApi>();
  CoachesApi _apiCoaches = locator<CoachesApi>();
  CourseApi _apiCourse = locator<CourseApi>();
  ConfigurationApi _configurationApi = locator<ConfigurationApi>();

  List<Category> categories;
  List<Coach> coaches;
  List<Course> courses;
  String versionCheck;

  UserApi _userApi = locator<UserApi>();
  int _id;

  int _scroll = 0;

  get scroll => _scroll;

  void setScroll(int value){
    _scroll = value;
    notifyListeners();
  }



  int _refresh = 0;

  get refresh => _refresh;

  void setRefresh(int value){
    _refresh = value;
    notifyListeners();
  }

  Future getCategories() async {
    setState(ViewState.Busy);
    categories = await _apiCategories.getCategories();
    setState(ViewState.Idle);
  }

  Future getCoaches() async {
    setState(ViewState.Busy);
    coaches = await _apiCoaches.getCoaches();
    setState(ViewState.Idle);
  }

  Future getCourses() async {
    setState(ViewState.Busy);
    courses = await _apiCourse.getCourses();
    setState(ViewState.Idle);
  }

  Future<String> checkUpdates() async {
    setState(ViewState.Busy);
    versionCheck = await _configurationApi.checkUpdates();
    setState(ViewState.Idle);
    if(versionCheck == 'ok'){
      print('ok');
    }else if(versionCheck == null){

    }else{
      print('res = ${versionCheck}');

    }
    return versionCheck;
  }

  Future<User> getUser() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    if(user != null){
      _id = user.getInt(Constants.PREF_ID);
      if (_id != null) {
        setState(ViewState.Busy);
        User res = await _userApi.getUser(_id);
        if(res == null ){
          UserManager userManager2 = new UserManager();
          userManager2.logout();
        }
        setState(ViewState.Idle);
        return res;
      }
    }
    return null;
  }
}
