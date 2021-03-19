import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
import 'package:ver2/Components/SplashScreen.dart';
import '../Components/BarChart.dart';
import 'package:flutter/material.dart';
import 'package:ver2/Models/MyCaseList.dart';
class MyCase extends StatefulWidget {
  static String id = "MyCase";

  @override
  _MyCaseState createState() => _MyCaseState();
}

class _MyCaseState extends State<MyCase> {
  List<MyCaseList> graphDate = [];
  bool getData = false;
  String firstName;

  @override
  Widget build(BuildContext context) {
    int count = 0;
    Size size = MediaQuery.of(context).size;
    firstName = Provider.of<CaseProvider>(context).loggedInUsername();
    print(firstName);
    setState(() {
      try{
        graphDate = Provider.of<CaseProvider>(context,listen: false).getCase();
        if(graphDate != null){
          getData = true;
          String todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
          graphDate.map((value) {
            if(value.assign_to == loggedUserDetail && value.hearing_date == todayDate){
              setState(() {
                count++;
              });
            }
          }).toList();
        }
        // else{
        //   graphDate = [];
        // }
      }
      catch(e){
        print("");
      }
    });

    return SingleChildScrollView(
      child: getData == true ? Column(

        children: [

          SizedBox(height: 20,),

          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 32.0,
                backgroundColor: Color.fromRGBO(167, 208, 251, 1),
                child: loggedUserDetail == 'DM' ? Text("DM") :
                      loggedUserDetail == 'ADC(E)' ? Text("ADC\n (E)") :
                      loggedUserDetail == 'ADC(HQ)' ? Text('''ADC\n(HQ)''') :
                      loggedUserDetail == 'SDM(E)' ? Text("SDM\n (E)") :
                      loggedUserDetail == 'SDM(HQ)' ? Text('''SDM\n(HQ)''') : Text(""),
              ),
              title: Text("$dataAssignedTo",style: TextStyle(fontSize: 24),),
              subtitle: Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Cases: $count"),
                    Text(" District East")
                  ],
                ),
              ),
            ),
          ),

          Center(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Card(
                  elevation: 3,
                  child: BarChart(graphDate: graphDate,))
          ),
          ),

        ],

      ) :
        Container(
          height:size.height *0.8,
          child: Center(child: Text("Error Connecting To NIC Network", style: TextStyle(fontWeight: FontWeight.bold),),)),
    );
  }
}




