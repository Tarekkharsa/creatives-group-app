

import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class CourseApi {
  List<Course> courseList;
  Course course;

  Future<List<Course>> getCourses() async {
      print('getCourses');
    try {
      Response response = await Dio().get("${Constants.URL}getCourses?limit=4");
      if (response.statusCode == 200) {
        courseList = Course.fromJsonList(response.data['data']);
      }
    } catch (e) {
      return null;
    }
    return courseList;
  }

  Future<List<Course>> search(name) async {
    print('search');
    try {
      Response response = await Dio().get("${Constants.URL}searchCourse?q=${name}");
      if (response.statusCode == 200) {
        courseList = Course.fromJsonList(response.data['data']);
        print(response);
      }
    } catch (e) {
      return null;
    }
    return courseList;
  }


  Future<Course> getCourse(id) async {
    print('getCourse');
    try {
      Response response = await Dio().get("${Constants.URL}getCourse?id=${id}");
      if (response.statusCode == 200) {
        course = Course.fromJson(response.data['data']);
        print(response.data['data']);
      }
    } catch (e) {
      return null;
    }
    return course;
  }
}