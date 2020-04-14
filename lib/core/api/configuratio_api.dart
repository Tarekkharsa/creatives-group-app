import 'package:creativesapp/core/models/Configuration.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class ConfigurationApi {
  List<Configuration> configurations;

  Future<List<Configuration>> getConfigurations() async {
    print('getConfigurations');
    try {
      Response response = await Dio().get("${Constants.URL}getConfigrations");
      if (response.statusCode == 200) {
        configurations = Configuration.fromJsonList(response.data['data']);
        print(response);
      }
    } catch (e) {
      return null;
    }
    return configurations;
  }

  Future<String> checkUpdates() async {
    print('checkUpdates');
    String msg;
    var data = {
      'key': Constants.KEY,
    };
    try {
      Response response =
          await Dio().post("${Constants.URL}config/checkUpdates", data: data);

      if (response.statusCode == 200) {
        msg = response.data['message'];
        return msg;
      }
    } catch (e) {
      if (e.response.statusCode == 499) {
        msg = e.response.data['message'];
      }
    }
    return msg;
  }
}
