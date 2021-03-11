import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
import 'package:ver2/Components/NotificationPlugin.dart';
import 'package:ver2/Components/SplashScreen.dart';
import 'package:ver2/Components/navdrawer.dart';
import 'package:ver2/Screens/CaseSearchScreen.dart';
import 'package:ver2/Screens/CaseStatus.dart';
import 'package:ver2/Screens/MyCase.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'CaseList.dart';

class StartPage extends StatefulWidget {
  static String id = "StartPage";

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin{
  TabController _controller;
  // int _selectedIndex = 0;

  TabBar get _tabBar => TabBar(
    indicatorColor: Colors.yellow,

    onTap: (index){
      //swipe is also a tap but now it isnt because of the controller
    },
    controller: _controller,
    tabs: list,
    unselectedLabelColor: Colors.black,
    labelColor: Colors.white,
  );

  List<Widget> list = [
    Tab(text: """
    My
   Case""",icon: new Icon(MdiIcons.human,)),
    Tab(text: """
    Case 
   Search""",icon: new Icon(MdiIcons.briefcaseSearch,)),
    Tab(text: """
    Case 
   Status""",icon: new Icon(MdiIcons.listStatus,)),
    Tab(text: """
    Case 
     List""",icon: new Icon(MdiIcons.clipboardList,)),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: list.length, vsync: this);
    // _controller.addListener(() {
    //   _selectedIndex = _controller.index;
    // });
    getToogleData().whenComplete(() async=> null);
  }

  Future getToogleData() async{

    if(toogleData == null){
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool('notificationToogle', false);
    }
    else{
      if(toogleData == true){
        await notificationPlugin.showDailyMorningAtTime();
      }
    }
  }

  @override
  Widget build(BuildContext context) {



    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: NavDrawer(),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 40,
            child: Image.asset("assets/flutter_footer.png"),
          )
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                Provider.of<CaseProvider>(context,listen: false).setCase();
                Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Refreshing....."),
                      backgroundColor: Colors.blueAccent,
                    )
                );

              });
            },
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromRGBO(20, 78, 188, 1),
          actions: [

            Image.asset("assets/scaleIMG.png",fit: BoxFit.cover,height: 35,)


          ],
          title: Text("CCMS",
            style: TextStyle(color: Colors.black),
          ),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color:  Colors.lightBlue,
                child: Material(
                  color: Color.fromRGBO(3, 127, 242, 1),
                  child: _tabBar,
                )
            ),
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            MyCase(),
            CaseSearchScreen(),
            CaseStatus(),
            CaseList(),
          ],
        ),

      ),
    );
  }
}
