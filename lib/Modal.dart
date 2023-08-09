class UserData {
  int page;
  int perPage;
  int total;
  int totalPages;
  List<User> data;
  Support support;

  UserData({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
    required this.support,
  });
}

class User {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });
}

class Support {
  String url;
  String text;

  Support({
    required this.url,
    required this.text,
  });
}
