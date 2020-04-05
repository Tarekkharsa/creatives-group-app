import 'State.dart';

class User {
  int id;
  String name;
  String email;
  String phone;
  String password;
  String image;
  String token;
  String university_id;
  State state;

  User({
    this.id,
    this.phone,
    this.password,
    this.name,
    this.token,
    this.image,
    this.university_id,
    this.email,
    this.state
  });




  factory User.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : User(
            id: json['id'],
            email: json['email'],
            phone: json['phone'],
            password: json['password'],
            name: json['name'],
            token: json['token'],
            image: json['image'],
            university_id: json['university_id'].toString(),
            state: State.fromJson(json['pivot']),
          );
  }

  static List<User> fromJsonList(List<dynamic> items) {
    items ??= [];
    List<User> users = [];
    for (var x in items) {
      users.add(User.fromJson(x));
    }
    return users;
  }
}
