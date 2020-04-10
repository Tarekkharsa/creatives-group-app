


import 'dart:async';

import 'package:creativesapp/core/api/course_api.dart';
import 'package:creativesapp/core/api/user_api.dart';
import 'package:creativesapp/core/api/user_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/core/services/authentication_service.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:creativesapp/core/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../locator.dart';

class CourseModel extends BaseModel{
  CourseApi _apiCourse = locator<CourseApi>();
  UserApi _userApi  = locator<UserApi>();
  Course course;
  int userState = 0;
  int studentId;
  int _id;
  String msg;








  Future registerCourse(data) async{
    setState(ViewState.Busy);
   msg = await _userApi.registerCourse(data);
    setState(ViewState.Idle);

  }


  Future getCourse(id) async {
    SharedPreferences user = await SharedPreferences.getInstance();

    setState(ViewState.Busy);
    course = await _apiCourse.getCourse(id);
    if(user != null){
      _id = user.getInt(Constants.PREF_ID);
    for(var x in course.students){
//      print(x.name);
      if(x.id == _id ){
        userState = x.state.status_id;
        print(x.state.status_id);
      }
    }
    }

    setState(ViewState.Idle);
  }





}