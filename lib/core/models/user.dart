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
  String firebase_token;
  String verification_code;

  User({
    this.id,
    this.phone,
    this.password,
    this.name,
    this.token,
    this.image,
    this.university_id,
    this.email,
    this.state,
    this.firebase_token,
    this.verification_code,
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
            firebase_token: json['firebase_token'],
            verification_code: json['verification_code'],
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
