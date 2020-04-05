



import 'package:creativesapp/core/api/category_api.dart';
import 'package:creativesapp/core/api/coaches_api.dart';
import 'package:creativesapp/core/api/course_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/category.dart';
import 'package:creativesapp/core/models/coach.dart';
import 'package:creativesapp/core/models/course.dart';
import '../../locator.dart';
import 'base_model.dart';

class AllCoursesModel extends BaseModel {

  CourseApi _apiCourse = locator<CourseApi>();

  List<Course> courses;
  String _courseName;

  String get courseName => _courseName;

  void setCourseName(String vlaue){
    _courseName = vlaue;
    notifyListeners();
  }

  Future getCourses(name) async {
    setState(ViewState.Busy);
    courses = await _apiCourse.search(name);
    setState(ViewState.Idle);
  }
}
