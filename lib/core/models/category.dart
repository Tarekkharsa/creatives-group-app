

class Category {
  String name;
  int id;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : Category(
            id: json['id'],
            name: json['name'],
          );
  }

  static List<Category> fromJsonList(List<dynamic> items) {
    items ??= [];
    List<Category> categories = [];
    for (var x in items) {
      categories.add(Category.fromJson(x));
    }
    return categories;
  }
}
