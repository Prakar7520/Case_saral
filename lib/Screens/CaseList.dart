import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ver2/Components/DatabaseStuffs/CaseProvider.dart';
import 'package:ver2/Components/SplashScreen.dart';
import 'detailsScreen.dart';
import 'package:ver2/Models/DetailScreenArgument.dart';
import 'package:ver2/Models/MyCaseList.dart';
import 'package:ver2/Screens/detailsScreen.dart';

class CaseList extends StatefulWidget {
  @override
  _CaseListState createState() => _CaseListState();
}

class _CaseListState extends State<CaseList> {
  //Swipe to Refresh
  Color gradientStart = Colors.white10;
  Color gradientEnd = Color.fromRGBO(201, 226, 252, 1);
    List<MyCaseList> cases = [];


  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {

    List<MyCaseList> caseListToday = [];
    bool getData = false;

    setState(() {
      cases = Provider.of<CaseProvider>(context).getCase();
      if(cases != null){
        getData = true;
        cases.map((value) {
          if(value.assign_to == loggedUserDetail || value.valid == 1){//here also and changed to or
            if(value.hearing_date == DateFormat('dd/MM/yyyy').format(DateTime.now())){
              caseListToday.add(value);
            }
          }
        }).toList();

      }

    });

    return getData == true ? Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, .9),
      body: caseListToday.length != 0 ? Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              elevation: 7.0,
              margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [gradientStart, gradientEnd],
                      begin: FractionalOffset(0, 0),
                      end: FractionalOffset(0, 1),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    title: Text(
                      "Case ID:${caseListToday[index].case_id.toString()}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),

                    //subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(caseListToday[index].date,
                            style: TextStyle(color: Colors.black)),
                        Text(caseListToday[index].petitioner,
                            style: TextStyle(color: Colors.black)),
                        Text(caseListToday[index].respondent,
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                    trailing: Container(
                        child: new IconButton(
                            icon: new Icon(Icons.keyboard_arrow_right,
                                color: Colors.black, size: 30.0),
                            onPressed: () {
                              Navigator.pushNamed(context, DetailsScreen.id,
                                  arguments: DetailScreenArgument(
                                      caseId:
                                          caseListToday[index].case_id,
                                      petitioner: caseListToday[index].petitioner,
                                      serialNo: caseListToday[index].serial_no,
                                      action: caseListToday[index].action,
                                      respondent: caseListToday[index].respondent,
                                      caseType: caseListToday[index].case_type,
                                      assignTo:caseListToday[index].assign_to,
                                      peshkarRmks: caseListToday[index].peskhar_rmks,
                                      date: caseListToday[index].date,
                                      officerRmks: caseListToday[index].officer_rmks,
                                      hearingDate: caseListToday[index].hearing_date

                                  ));
                            }))),
              ),
            );
          },
          itemCount: caseListToday.length,
        ),
      ): Center(child: Text("No cases for today", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),)),
    ) : Container(
        height:300,
        child: Center(child: Text("Error Connecting To NIC Network", style: TextStyle(fontWeight: FontWeight.bold),),)
    );
  }
}
