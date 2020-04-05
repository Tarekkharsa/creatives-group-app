import 'package:creativesapp/core/models/category.dart';
import 'package:creativesapp/core/models/coach.dart';
import 'package:creativesapp/core/models/contact.dart';
import 'package:creativesapp/core/models/location.dart';
import 'package:creativesapp/core/models/user.dart';

class Course {
  String title, description, address;
  int id, cost;
  String cover;
  String start_date, end_date;
  Category category;
  List<Coach> coaches;
  Contact contact;
  Location location;
  List<User> students;

  Course(
      {this.id,
      this.title,
      this.description,
      this.address,
      this.location,
      this.contact,
      this.cover,
      this.cost,
      this.start_date,
      this.end_date,
      this.coaches,
      this.category,
      this.students});

  factory Course.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : Course(
            id: json['id'],
            title: json['title'],
            description: json['description'],
            address: json['address'],
            cost: json['cost'],
            cover: json['cover'],
            location: Location.fromJson(json['location']),
            start_date: json['start_date'],
            end_date: json['end_date'],
            contact: Contact.fromJson(json['contacts']),
            coaches: Coach.fromJsonList(json['coaches']),
            students: User.fromJsonList(json['students']),
            category: Category.fromJson(json['category']));
  }

  static List<Course> fromJsonList(List<dynamic> items) {
    items ??= [];
    List<Course> courses = [];
    for (var x in items) {
      courses.add(Course.fromJson(x));
    }
    return courses;
  }
}
