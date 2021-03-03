import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
import 'package:ver2/Models/UserModel.dart';
import 'package:ver2/Screens/StartPage.dart';
import 'package:ver2/main.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

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
  final TextEditingController _password = TextEditingController();

  List<String> graphDate;

  @override
  void initState() {
    super.initState();
  }
  // FOR INVALID POP ALERT STUFF///////////////////////////



  @override
  Widget build(BuildContext context) {

    Provider.of<CaseProvider>(context).setUser();
    widget.user = Provider.of<CaseProvider>(context,listen: false).getUser();


    return new Form(
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.purple,
          ),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              backgroundColor: Colors.blueAccent[100],
              appBar: AppBar(
                backgroundColor: Colors.blue[700],
                title: Text(
                  'CCMS',
                ),
              ),
              body: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                      child: Container(
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                color: Colors.blueAccent[100],
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.30,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor:
                                        Theme
                                            .of(context)
                                            .accentColor,
                                        radius: 40,
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                        ),
                                      ),
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          autocorrect: false,
                                          onChanged: (value){
                                            setState(() {
                                              con1 = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Username',
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  20),
                                              borderSide: BorderSide(
                                                color: Theme
                                                    .of(context)
                                                    .accentColor,
                                                width: 3,
                                              ),
                                            ),
                                            prefixIcon: IconTheme(
                                              data: IconThemeData(
                                                color: Theme
                                                    .of(context)
                                                    .accentColor,
                                              ),
                                              child: Icon(Icons.email),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        TextFormField(
                                          autocorrect: false,
                                          controller: _password,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  20),
                                              borderSide: BorderSide(
                                                color: Theme
                                                    .of(context)
                                                    .accentColor,
                                                width: 3,
                                              ),
                                            ),
                                            prefixIcon: IconTheme(
                                              data: IconThemeData(
                                                color: Theme
                                                    .of(context)
                                                    .accentColor,
                                              ),
                                              child: Icon(Icons.lock),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.5,
                                          child: Center(
                                            child: FlatButton(
                                              onPressed: () async{
                                                final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                                try{
                                                  if(widget.user != null){
                                                  for(var ur in widget.user){
                                                    if(con1 == ur.username && _password.text == ur.password){
                                                      sharedPreferences.setString('LoggedUser', ur.username);
                                                      RestartWidget.restartApp(context);
                                                      Navigator.pushReplacement(context, MaterialPageRoute(
                                                          builder: (context) => StartPage()
                                                      ));
                                                      break;
                                                    }
                                                  }
                                                }
                                                  if(widget.user == null){
                                                    setState(() {

                                                    });
                                                  }
                                                  if(userExist == false){
                                                    _popupDialog(context);
                                                  }
                                                }catch(e){
                                                  print("Exception ");
                                                }
                                              },
                                              padding: EdgeInsets.all(16),
                                              color: Theme
                                                  .of(context)
                                                  .accentColor,
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
                                        ),
                                        SizedBox(height: 30,),
                                        Column(
                                          children: [
                                            Divider(height: 12,color: Colors.black,)
                                          ],
                                        ),
                                        SizedBox(height: 30,),
                                    RichText(
                                      text: TextSpan(
                                        text: 'For any help, please contact ',
                                        style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' 7318718159',
                                              style: TextStyle(color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                setState(() {
                                                  _makePhoneCall('tel:7318718159');
                                                });
                                                }),
                                        ],
                                      ),
                                    )
                                      ],
                                    ),
                                  )
                              ),
                              //Here is if u wanna put anything at the bottom bar
                            ],
                          ),
                        ),
                      ),
                    ),
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
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),

            ],
          );
        });
  }
}


