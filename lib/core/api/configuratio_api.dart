

import 'package:creativesapp/core/models/Configuration.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class ConfigurationApi{
List<Configuration> Configurations;

  Future<List<Configuration>> getConfigurations() async {
    print('getConfigurations');
    try {
      Response response =
      await Dio().get("${Constants.URL}getConfigrations");
      if (response.statusCode == 200) {
        Configurations = Configuration.fromJsonList(response.data['data']);
        print(response);
      }
    } catch (e) {
      return null;
    }
    return Configurations;
  }

}