

import 'dart:io';

import 'package:creativesapp/core/api/course_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/core/models/query.dart';
import 'package:creativesapp/core/models/user.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../locator.dart';
import 'base_model.dart';

class QueriesModel extends BaseModel {
  CourseApi _apiCourse = locator<CourseApi>();
  List<Course> courses;
  List<Query> queries;





  Future getCourses() async {
    setState(ViewState.Busy);
    courses = await _apiCourse.getCourses();
    setState(ViewState.Idle);
  }


}