import 'package:creativesapp/core/models/university.dart';

class Coach {
  String phone, brief, name, email;
  int id;
  String image;
  University university;

  Coach(
      {this.id,
      this.name,
      this.brief,
      this.phone,
      this.image,
      this.email,
      this.university});

  factory Coach.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : Coach(
            id: json['id'],
            name: json['name'],
            brief: json['brief'],
            email: json['email'],
            phone: json['phone'],
            image: json['image'],
            university: University.fromJson(json['university']));
  }

  static List<Coach> fromJsonList(List<dynamic> items) {
    items ??= [];
    List<Coach> coaches = [];
    for (var x in items) {
      coaches.add(Coach.fromJson(x));
    }
    return coaches;
  }
}
