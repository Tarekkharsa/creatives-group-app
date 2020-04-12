

import 'package:creativesapp/core/api/feed_back_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/viewmodels/base_model.dart';
import 'package:creativesapp/locator.dart';

class FeedBackModel extends BaseModel {

  FeedBackApi _feedBackApi = locator<FeedBackApi>();

  Future sendFeedBack(data) async {
    setState(ViewState.Busy);
    _feedBackApi.sendFeedBack(data);
    setState(ViewState.Idle);
  }
}