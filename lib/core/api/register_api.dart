import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/services/user_manager.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class RegisterApi {
  User user;
  UserManager userManager = new UserManager();

  Future<int> register(data) async {
    int check = 404;
    String url = '${Constants.URL}addStudent';
    try {
      var response = await Dio().post(url, data: data);
      if (response.statusCode == 200) {
        check = 200;
        user = User.fromJson(response.data['data']);
        if (user != null) {
          userManager.login(user);
        }
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        check = 404;
        print('timeout');
      }
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          print('404');
          print(e.response.statusCode);
        } else if (e.response.statusCode == 400) {
          check = 400;
          print(e.response.statusCode);
          print(e.request.data);
          print(e.response.data['message']);
        }
      }
    }

    return check;
  }
}
