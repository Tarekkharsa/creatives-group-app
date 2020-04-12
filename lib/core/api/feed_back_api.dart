

import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class FeedBackApi{

String msg;


  Future<String> sendFeedBack(data) async {
    print('sendFeedBack');
    String url = '${Constants.URL}feedback/add';
    try {
      Response response = await Dio().post(url, data: data);
      if (response.statusCode == 200) {
        msg = response.data['data'];
        print(response.data['data']);
      }
    } catch (e) {
      return null;
    }
    return msg;
  }

}