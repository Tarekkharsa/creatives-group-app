import 'package:creativesapp/core/api/user_api.dart';
import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/services/user_manager.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:creativesapp/locator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginApi {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  UserApi _userApi = locator<UserApi>();

  User user;
  UserManager userManager = new UserManager();

  Future<String> login(data) async {
    String check ;
    String url = '${Constants.URL}student_login';
    try {
      var response = await Dio().post(url, data: data);
      if (response.statusCode == 200) {
        check = '200';
        user = User.fromJson(response.data['data']);
        if (user != null) {
          userManager.login(user);
        }
      
          var data;
        String token =  await _fcm.getToken();
             data = {
              'id' : user.id,
              'firebase_token' : token,
            };
          print('data = ${data}');
           await _userApi.updateUser(data);
        
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        check = '404';
        print('timeout');
      }
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          check = '404';
          print(e.response.statusCode);
        } else if (e.response.statusCode == 400) {
          check = e.response.data['message'];

        }
      }
    }

    return check;
  }
}
