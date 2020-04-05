class State{

  int course_id;
  int student_id;
  int status_id;

  State({this.course_id, this.student_id, this.status_id});

  factory State.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : State(
      course_id: json['course_id'],
      student_id: json['student_id'],
      status_id: json['status_id'],
    );
  }

}