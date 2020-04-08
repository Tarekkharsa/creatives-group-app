



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
  CategoryApi _apiCategories = locator<CategoryApi>();

  List<Category> categories;
  List<Course> courses;


  int _isSearch = 0;

  int get isSearch => _isSearch;

  void setIsSearch(int vlaue){
    _isSearch = vlaue;
    notifyListeners();
  }



  Future search(name) async {
    setState(ViewState.Busy);
    courses = await _apiCourse.search(name);
    setState(ViewState.Idle);
  }

  Future getCoursesByCategory(id) async {
    print('getCoursesByCategory');
    setState(ViewState.Busy);
    courses = await _apiCourse.getCoursesByCategory(id);
    setState(ViewState.Idle);
  }

  Future getCategories() async {
    setState(ViewState.Busy);
    categories = await _apiCategories.getCategories();
    setState(ViewState.Idle);
  }

}
