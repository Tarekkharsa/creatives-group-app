import 'package:creativesapp/core/models/university.dart';

class Configuration {
  int id;
  String key, value;


  Configuration(
      {this.id,
        this.key,
        this.value,
      });

  factory Configuration.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : Configuration(
        id: json['id'],
        key: json['key'],
        value: json['value'],
       );
  }

  static List<Configuration> fromJsonList(List<dynamic> items) {
    items ??= [];
    List<Configuration> configurations = [];
    for (var x in items) {
      configurations.add(Configuration.fromJson(x));
    }
    return configurations;
  }
}
