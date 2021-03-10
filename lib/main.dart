import 'package:provider/provider.dart';
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
import 'package:ver2/Components/SettingPage.dart';
import 'package:ver2/Screens/AddRemarks.dart';
import 'package:ver2/Screens/CaseSearchScreen.dart';
import 'package:ver2/Screens/CaseStatus.dart';
import 'package:ver2/Screens/DMHistory.dart';
import 'package:ver2/Screens/LoginScreen.dart';
import 'package:ver2/Screens/MyCase.dart';
import 'package:ver2/Screens/StartPage.dart';
import 'package:ver2/Screens/WelcomeInstruction.dart';
import 'package:ver2/Screens/detailsScreen.dart';
import 'package:flutter/material.dart';


import 'Components/SplashScreen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      RestartWidget(
          child: MyApp()
      ),
  );
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}


// class RestartWidget extends StatefulWidget {
//   RestartWidget({this.child});
//
//   final Widget child;
//
//   static void restartApp(BuildContext context) {
//     context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
//   }
//
//   @override
//   _RestartWidgetState createState() => _RestartWidgetState();
// }
//
// class _RestartWidgetState extends State<RestartWidget> {
//   Key key = UniqueKey();
//
//   void restartApp() {
//     setState(() {
//       key = UniqueKey();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(
//       key: key,
//       child: widget.child,
//     );
//   }
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CaseProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: SplashScreen.id,
        routes:{
          SettingPage.id: (context) => SettingPage(),
          WelcomeInstruction.id: (context) => WelcomeInstruction(),
          DMHistory.id: (context) => DMHistory(),
          LoginScreen.id:(context) => LoginScreen(),
          MyCase.id: (context) => MyCase(),
          CaseSearchScreen.id: (context) => CaseSearchScreen(),
          CaseStatus.id: (context) => CaseStatus(),
          SplashScreen.id: (context) => SplashScreen(),
          StartPage.id: (context) => StartPage(),
          DetailsScreen.id: (context) => DetailsScreen(),
          AddRemarks.id: (context) => AddRemarks(),
        },
      ),
    );
  }
}


