class Contact {
  int id;
  String email, phone, whatsapp;

  Contact({this.id, this.email, this.phone, this.whatsapp});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return json == null || json.isEmpty
        ? null
        : Contact(
            id: json['id'],
            email: json['email'],
            phone: json['phone'],
            whatsapp: json['whatsapp'],
          );
  }
}
