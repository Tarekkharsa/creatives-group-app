

import 'package:creativesapp/core/models/feedBack.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FeedBackApi{

MyFeedBack msg;


  Future<MyFeedBack> sendFeedBack(data) async {
    print('sendFeedBack');
    String url = '${Constants.URL}feedback/add';
    try {
      Response response = await Dio().post(url, data: data);
      if (response.statusCode == 200) {
      
      msg =MyFeedBack.fromJson(response.data['data']);
      }
    } catch (e) {
      return null;
    }
    return msg;
  }

}