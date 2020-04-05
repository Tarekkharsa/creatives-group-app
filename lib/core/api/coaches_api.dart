import 'package:creativesapp/core/models/coach.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class CoachesApi {
  List<Coach> coaches;

  Future<List<Coach>> getCoaches() async {
    print('getCoaches');
    try {
      Response response = await Dio().get("${Constants.URL}getCoaches");
      if (response.statusCode == 200) {
        coaches = Coach.fromJsonList(response.data['data']);
        print(response);
      }
    } catch (e) {
      return null;
    }
    return coaches;
  }
}
