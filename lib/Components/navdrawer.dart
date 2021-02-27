import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ver2/Components/SplashScreen.dart';
import 'package:ver2/Screens/DMHistory.dart';
import 'package:ver2/Screens/FeedbackScreen.dart';
import 'package:ver2/Screens/LoginScreen.dart';
import 'package:ver2/Screens/WelcomeInstruction.dart';
import 'package:ver2/main.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {

  String logUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.black,
//                image: DecorationImage(
//                    fit: BoxFit.fill,
//                    image: AssetImage('assets/images/cover.jpg'))
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('About'),
            onTap: () => {
              Navigator.pushNamed(context, WelcomeInstruction.id)
            },
          ),
          userLoggedIn == "DM" ? ListTile(
            leading: Icon(Icons.history),
            title: Text("Officer's Cases"),
            onTap: (){
              Navigator.pushNamed(context, DMHistory.id);
            },
          ): Container(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.pushNamed(context, FeedbackScreen.id)},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async{
              final SharedPreferences sharedPreference = await SharedPreferences.getInstance();
              setState(() {
                sharedPreference.remove('LoggedUser');
              });
              RestartWidget.restartApp(context);
              },
          ),
        ],
      ),
    );
  }
}