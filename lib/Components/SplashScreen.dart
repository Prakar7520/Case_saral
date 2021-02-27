import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
import 'package:ver2/Components/Spinner.dart';
import 'package:ver2/Screens/LoginScreen.dart';
import 'package:ver2/Screens/StartPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String userLoggedIn;

class SplashScreen extends StatefulWidget {
  static String id = "SplashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<CaseProvider>(context,listen: false).setCase();
    super.initState();
    getValidationData().whenComplete(() async{
      startTime();
    });
  }

  Future getValidationData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('LoggedUser');
    setState(() {
      userLoggedIn = obtainedEmail;
    });
  }

  startTime() async{
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route(){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => userLoggedIn == null ? LoginScreen() : StartPage()
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return userLoggedIn == null ? Scaffold(
        body: Stack(
          children: [

            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Background1.png"),
                      fit: BoxFit.cover
                  )
              ),
            ),

            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [

                      Container(
                        child: Image.asset("assets/govtofsikkim1.png"),
                        height: 160,
                        width: 160,
                      ),

                      Text("Government Of Sikkim", style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                      ),),
                      Text("CCMS",style: TextStyle(
                        fontSize: 12,
                      ),),

                      SizedBox(height: 60,),

                      Container(
                        height: 80,
                        width: 80,
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(29),
                          gradient: LinearGradient(

                              colors: [Colors.lightBlueAccent,Colors.grey],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight
                          ),),
                        child: Center(
                          child: FlatButton(
                            onPressed: (){},
                            child: Icon(Icons.book,size: 30,),
                          ),
                        ),
                      ),

                      Text("""
              Court Case
      Management System"""),

                      SizedBox(height: 20,),

                      userLoggedIn == null ? Text("") : Text("$userLoggedIn"),

                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                Container(
                                  child: Image.asset("assets/nicLogo.jpg"),
                                  height: 100,
                                  width: 100,
                                ),

                                Container(
                                  child: Image.asset("assets/digital_india.png"),
                                  height: 100,
                                  width: 100,
                                ),

                              ],
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      ):
    // Scaffold(
    //   backgroundColor: Colors.lightBlueAccent,
    //   body: SingleChildScrollView(
    //     child: SafeArea(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //
    //           Spinner(),
    //
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Background1.png"),
                    fit: BoxFit.cover
                )
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [

                    Container(
                      child: Image.asset("assets/govtofsikkim1.png"),
                      height: 160,
                      width: 160,
                    ),

                    Text("Government Of Sikkim", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400
                    ),),
                    Text("CCMS",style: TextStyle(
                      fontSize: 12,
                    ),),

                    SizedBox(height: 60,),

                    Spinner(),
                    SizedBox(height: 12,),
                    Text("$userLoggedIn",style: TextStyle(fontSize: 20),),

                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Container(
                                child: Image.asset("assets/nicLogo.jpg"),
                                height: 100,
                                width: 100,
                              ),

                              Container(
                                child: Image.asset("assets/digital_india.png"),
                                height: 100,
                                width: 100,
                              ),

                            ],
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );

  }
}
