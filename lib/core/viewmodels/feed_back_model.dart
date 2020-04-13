import 'package:creativesapp/core/api/feed_back_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/feedBack.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:creativesapp/core/viewmodels/base_model.dart';
import 'package:creativesapp/locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBackModel extends BaseModel {
  FeedBackApi _feedBackApi = locator<FeedBackApi>();

  Future<MyFeedBack> sendFeedBack(text) async {
    MyFeedBack res ;
    SharedPreferences user = await SharedPreferences.getInstance();
    if (user != null) {
      int id = user.getInt(Constants.PREF_ID);
      var data = {
        'description': text,
        'student_id': id,
      };

      setState(ViewState.Busy);
     res = await _feedBackApi.sendFeedBack(data);
     print('res from model = ${res}');
      setState(ViewState.Idle);
    }
    return res;
  }
}
