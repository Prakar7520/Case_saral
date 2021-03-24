import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ver2/Components/SplashScreen.dart';
import 'package:ver2/Screens/DMHistory.dart';
import 'package:ver2/Screens/WelcomeInstruction.dart';
import 'package:ver2/main.dart';
import 'package:ver2/Components/SettingPage.dart';
import '../Screens/ReachUs.dart';
import 'DatabaseStuffs/CaseProvider.dart';

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

          userLoggedIn == "DM" ? ListTile(
            leading: Icon(Icons.history),
            title: Text("Officer's Cases"),
            onTap: (){
              String officerName = "ADC(E)";
              String dateNowSearch = DateFormat('ddMMyyyy').format(DateTime.now());
              Provider.of<CaseProvider>(context,listen: false).setDateAssign(dateNowSearch, officerName);
              Navigator.pushNamed(context, DMHistory.id);
            },
          ): Container(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {
              Navigator.pushNamed(context, SettingPage.id)
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReachUS()),
            )
            },
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('About'),
            onTap: () => {
              Navigator.pushNamed(context, WelcomeInstruction.id)
            },
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