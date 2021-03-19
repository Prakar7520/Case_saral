class LoginModel{

  final String token;

  LoginModel({this.token});

  Map toJson() => {

    "token": token,

  };

  LoginModel.fromJson(Map json):
        token = json["token"];

}