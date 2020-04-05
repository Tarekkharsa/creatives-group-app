class Location {
  int id;
  String name;

  Location({this.id, this.name});

  factory Location.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : Location(
            id: json['id'],
            name: json['name'],
          );
  }
}
