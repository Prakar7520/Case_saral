import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ver2/Components/Config.dart';
import 'package:ver2/Components/DatabaseStuffs/ApiResponse.dart';
import 'package:ver2/Components/Spinner.dart';
import 'package:ver2/Models/UserModel.dart';
import 'package:ver2/Screens/StartPage.dart';
import 'package:ver2/Services/Storage.dart';
import 'package:ver2/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../Models/LoginModel.dart';



Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
  List<UserModel> user;

  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool apiCall = false;
  bool userExist = false;

  String dialogHead = "";
  String dialogMessage = "";

  String con1 = "";
  String con2 = "";

  List<String> graphDate;
  Future<List<LoginModel>> loginUser( username, password) async  {
    final SecureStorage ss = await SecureStorage();


      var url1 ='http://10.182.65.28/mobilelogin';
     // Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"username": "$username", "password": "$password"}';
      // make POST request
      print(json);
      Response response = await post(url1, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
          body: json);
      print(username);
      print(password);
      //var v = await LoginModel.fromJson(jsonDecode(response.body));
      //print(v);

      print(response.statusCode);

      if(response.statusCode == 201){
        var x = jsonDecode(response.body);
        print(x["token"]);
        var tok=x["token"];
        print(tok);
        await ss.writeSecureData('token', tok);

//        Navigator.pushReplacement(context, MaterialPageRoute(
//            builder:  (context) => StartPage()));
        RestartWidget.restartApp(context);
      }
      else{
        Spinner();
      }



  }


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    Size size = MediaQuery.of(context).size;



    return new Form(
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.purple,
          ),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              // backgroundColor: Colors.blueAccent[100],

              body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints viewportConstraints){
                  return  Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: CustomPaint(
                              painter: HeaderPainter(),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 300
                              )
                          )
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: CustomPaint(
                              painter: FooterPainter(),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 300
                              )
                          )
                      ),

                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              SizedBox(height:100,),

                              Container(
                                height: 120,
                                width: 150,
                                child: Image.asset("assets/applogo.png"),
                              ),
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 60,),

                              InputField(size: size, onPressed: (value){
                                setState(() {
                                  con1 = value;
                                });
                              }, text: 'Username', passwordOn: false, newIcons: Icon(Icons.email),),
                              SizedBox(height: 4,),
                              InputField(size: size, onPressed: (value){
                                setState(() {
                                  con2 = value;


                                });
                              }, text: 'Password', passwordOn: true, newIcons: Icon(Icons.lock),),

                              SizedBox(height: 20,),

                              Container(
                                width: size.width * 0.5,
                                // ignore: deprecated_member_use
                                child: FlatButton(
                                  onPressed: () async{
                                    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                    try{
                                      //var b=EncryptPassword(con1);
                                      if(loginUser(con1, con2) != null)
                                      {
                                        sharedPreferences.setString('LoggedUser',con1);
                                      }
                                      //print(a);
                                    }catch(e){
                                      print("Exception ");
                                    }
                                  },
                                  padding: EdgeInsets.all(16),
                                  color: Color.fromRGBO(58, 133, 191, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 25,
                                        color: Colors.white,
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 60,),
                              Column(
                                children: [
                                  Container(
                                      width: size.width*0.8,
                                      child: Divider(height: 12,color: Colors.black,)
                                  )
                                ],
                              ),
                              SizedBox(height: 30,),

                              RichText(
                                text: TextSpan(
                                  text: 'For any help, please contact ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' 9910788993',
                                        style: TextStyle(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              _makePhoneCall('tel:9910788993');
                                            });
                                          }),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                      )
                    ],
                  );

                },
              )
          ),

        )
    );
  }
  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Login Credentials'),
            content: Text('Please Enter a valid username or password and also check if you are connected to NIC network'),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),
            ],
          );
        });
  }

//  EncryptPassword(String con1) {
//    final key = Key.fromUtf8('mysupersecretkey!!!');
//    final iv = IV.fromLength(16);
//
//    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
//    // if you need to use the ttl feature, you'll need to use APIs in the algorithm itself
//    final fernet = Fernet(b64key);
//    final encrypter = Encrypter(fernet);
//
//    final encrypted = encrypter.encrypt(con1);
//    final decrypted = encrypter.decrypt(encrypted);
//
//    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
//    print(encrypted.base64); // random cipher text
//    print(fernet.extractTimestamp(encrypted.bytes));
//    return encrypted.base64;// uqVowBXm36ZcCeN
//  }
}

class InputField extends StatelessWidget {

  final Size size;
  final bool passwordOn;
  final String text;
  final Function onPressed;
  final Icon newIcons;

  const InputField({
    Key key,
    @required this.size, this.passwordOn, this.text, this.onPressed, this.newIcons,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width *0.7,
      child: TextFormField(
        autocorrect: false,
        obscureText: passwordOn,
        onChanged: onPressed,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: IconTheme(
            data: IconThemeData(
              color: Theme.of(context).accentColor,
            ),
            child: newIcons,
          ),
        ),
      ),
    );
  }
}

class HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = Color.fromRGBO(20, 78, 118, 1);
    path = Path();
    path.lineTo(0, size.height);
    path.cubicTo(size.width * 0.09, size.height * 0.93, size.width * 0.11, size.height * 0.78,size.width * 0.11, size.height * 0.66);
    path.cubicTo(size.width * 0.11, size.height * 0.49, size.width * 0.16, size.height * 0.37,size.width / 4, size.height * 0.28);
    path.cubicTo(size.width * 0.36, size.height * 0.23, size.width * 0.54, size.height * 0.18,size.width * 0.68, size.height * 0.16);
    path.cubicTo(size.width * 0.81, size.height * 0.13, size.width * 0.89, size.height * 0.07,size.width * 0.98, 0);
    path.cubicTo(size.width * 0.94, 0, size.width * 0.86, 0,size.width * 0.84, 0);
    path.cubicTo(size.width * 0.56, 0, size.width * 0.28, 0,0, 0);
    path.cubicTo(0, 0, 0, size.height,0, size.height);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FooterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = Color.fromRGBO(3, 137, 242, 1);
    path = Path();
    path.lineTo(size.width, size.height / 5);
    path.cubicTo(size.width, size.height / 5, size.width * 0.94, size.height * 0.88,size.width * 0.65, size.height * 0.93);
    path.cubicTo(size.width * 0.36, size.height * 0.97, size.width / 5, size.height,size.width / 5, size.height);
    path.cubicTo(size.width / 5, size.height, size.width, size.height,size.width, size.height);
    path.cubicTo(size.width, size.height, size.width, size.height / 5,size.width, size.height / 5);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
