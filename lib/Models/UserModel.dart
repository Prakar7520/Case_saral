class UserModel{

  final String firstname;
  final String password;
  final String username;
  final int id;

  UserModel({this.firstname, this.password, this.username, this.id});

  Map toJson() => {

    'firstname': firstname,
    'password': password,
    'username': username,
    'id': id,
  };

  UserModel.fromJson(Map json):
        firstname = json['firstname'],
        password = json['password'],
        username = json['username'],
        id = json['id'];
}