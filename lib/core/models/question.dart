
import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/core/models/user.dart';

class Question {
  String question, answer;
  int id;
  String image;
  String updated_at ,created_at;
  User user;
  Course course;
  Question(
      {this.id,
        this.question,
        this.answer,
        this.image,
        this.created_at,
        this.updated_at,
        this.user,
        this.course,
      });

  factory Question.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : Question(
        id: json['id'],
        question: json['question'],
        answer: json['answer'],
        image: json['image'],
        user: User.fromJson(json['student']),
        course: Course.fromJson(json['course']),
        created_at:  json['created_at'],
        updated_at: json['updated_at'],


    );
  }

  static List<Question> fromJsonList(List<dynamic> items) {
    items ??= [];
    List<Question> questions = [];
    for (var x in items) {
      questions.add(Question.fromJson(x));
    }
    return questions;
  }
}
