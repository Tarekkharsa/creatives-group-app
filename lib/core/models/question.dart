
class Question {
  String question, answer,student_id, course_id;
  int id;
  String image;
  String updated_at ,created_at;

  Question(
      {this.id,
        this.question,
        this.answer,
        this.student_id,
        this.course_id,
        this.image,
        this.created_at,
        this.updated_at,
      });

  factory Question.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : Question(
        id: json['id'],
        question: json['question'],
        answer: json['answer'],
        student_id: json['student_id'].toString(),
        course_id : json['course_id'].toString(),
        image: json['image'],
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
