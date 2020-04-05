class University {
  String name;
  int id;
  University({this.name, this.id});

  factory University.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : University(id: json['id'], name: json['name']);
  }

  static List<University> fromJsonList(List<dynamic> items) {
    items ??= [];
    List<University> coaches = [];
    for (var x in items) {
      coaches.add(University.fromJson(x));
    }
    return coaches;
  }
}
