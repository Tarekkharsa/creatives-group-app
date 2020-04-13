
import 'package:creativesapp/core/api/configuratio_api.dart';
import 'package:creativesapp/core/api/feed_back_api.dart';
import 'package:creativesapp/core/api/question_api.dart';
import 'package:creativesapp/core/viewmodels/all_courses_model.dart';
import 'package:creativesapp/core/viewmodels/feed_back_model.dart';
import 'package:creativesapp/core/viewmodels/question_model.dart';
import 'package:get_it/get_it.dart';

import 'core/api/category_api.dart';
import 'core/api/coaches_api.dart';
import 'core/api/course_api.dart';
import 'core/api/login_api.dart';
import 'core/api/register_api.dart';
import 'core/api/university_api.dart';
import 'core/api/user_api.dart';
import 'core/services/authentication_service.dart';
import 'core/viewmodels/course_model.dart';
import 'core/viewmodels/drawer_model.dart';
import 'core/viewmodels/home_model.dart';
import 'core/viewmodels/login_model.dart';
import 'core/viewmodels/profile_model.dart';
import 'core/viewmodels/register_model.dart';


final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());

  // api
  locator.registerLazySingleton(() => CategoryApi());
  locator.registerLazySingleton(() => UserApi());
  locator.registerLazySingleton(() => CoachesApi());
  locator.registerLazySingleton(() => UniversityApi());
  locator.registerLazySingleton(() => LoginApi());
  locator.registerLazySingleton(() => RegisterApi());
  locator.registerLazySingleton(() => CourseApi());
  locator.registerLazySingleton(() => ConfigurationApi());
  locator.registerLazySingleton(() => FeedBackApi());
  locator.registerLazySingleton(() => QuestionApi());


  // view models
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => RegisterModel());
  locator.registerFactory(() => ProfileModel());
  locator.registerFactory(() => DrawerModel());
  locator.registerFactory(() => AllCoursesModel());
  locator.registerFactory(() => CourseModel());
  locator.registerFactory(() => QuestionModel());
  locator.registerFactory(() => FeedBackModel());
}
