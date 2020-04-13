class MyFeedBack {
  String description;
  int id;

  MyFeedBack({this.id, this.description});

  factory MyFeedBack.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : MyFeedBack(
            id: json['id'],
            description: json['description'],
          );
  }
}
