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
String loggedUserDetail;
String dataAssignedTo;
bool toogleData;

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
    getToogleData().whenComplete(() async=> null);
    getValidationData().whenComplete(() async{
      startTime();
    });
  }

  Future getToogleData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getBool('notificationToogle');
    setState(() {
      toogleData = obtainedEmail;
    });
  }

  Future getValidationData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedUser = sharedPreferences.getString('LoggedUser');

    setState(() {
      userLoggedIn = obtainedUser;
      if(obtainedUser == "DM"){
        dataAssignedTo = "District Magistrate";
        loggedUserDetail = "DM";
      }
      else if(obtainedUser == "ADCE"){
        dataAssignedTo = "Additional District Collector(East)";
        loggedUserDetail = "ADC(E)";
      }
      else if(obtainedUser == "ADCHQ"){
        dataAssignedTo = "Additional District Collector(HQ)";
        loggedUserDetail = "ADC(HQ)";
      }
      else if(obtainedUser == "SDME"){
        dataAssignedTo = "Sub Divisional Magistrate(East)";
        loggedUserDetail = "SDM(E)";
      }
      else{
        dataAssignedTo = "Sub Divisional Magistrate(HQ)";
        loggedUserDetail = "SDM(HQ)";
      }
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

            SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Container(
                    height: size.height,
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
                          height: 150,
                          width: 100,
                          child: Image.asset("assets/applogo.png"),
                        ),

                        Center(
                          child: Text("Court Case"),
                        ),
                        Center(
                          child: Text("  Management System"),
                        ),

                        SizedBox(height: 20,),


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
              ),
            )

          ],
        ),
      ):

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

          SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Container(
                  height: size.height,
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
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

                      Expanded(child: Spinner()),
                      SizedBox(height: 12,),
                      Text("$dataAssignedTo",style: TextStyle(fontSize: 20),),

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
            ),
          )

        ],
      ),
    );

  }
}
