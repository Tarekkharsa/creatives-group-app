import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/services/user_manager.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class UserApi {
  UserManager userManager = new UserManager() ;
  User user;
  String message;

  Future<User> getUser(int id) async {
    print('getUser');
    try {
      Response response =
          await Dio().get("${Constants.URL}getStudent?id=${id}");
      if (response.statusCode == 200) {
        user = User.fromJson(response.data['data']);
        print(response);
      }
    } catch (e) {
      return null;
    }
    return user;
  }

  Future<User> updateUser(data) async {
    print('updateUser ');
    String url = '${Constants.URL}updateStudent';
    try {
      Response response = await Dio().post(url, data: data);
      print(response);
      if (response.statusCode == 200) {
        user = User.fromJson(response.data['data']);

        userManager.logout();
        userManager.login(user);

        print(response);
      }
    } catch (e) {
      return null;
    }
    return user;
  }

  Future<String> registerCourse(data) async {
    print('register_course ');
    String url = '${Constants.URL}register_course';
    try {
      Response response = await Dio().post(url, data: data);
      if (response.statusCode == 200) {
         message = response.data['message'];
        print(message);
      }
    } catch (e) {
      return null;
    }
    return message ;
  }






}
