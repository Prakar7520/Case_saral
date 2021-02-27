import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
import 'package:ver2/Components/DatalnTable.dart';
import 'package:ver2/Components/StatusContainer.dart';
import 'package:flutter/material.dart';
import 'package:ver2/Models/MyCaseList.dart';


class CaseStatus extends StatefulWidget {
  static String id = "CaseStatus";

  @override
  _CaseStatusState createState() => _CaseStatusState();
}

class _CaseStatusState extends State<CaseStatus> {
  String dt = DateFormat('dd/MM/yyyy').format(DateTime.now());

  List<MyCaseList> cases = List<MyCaseList>();
  bool getData = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      cases = Provider.of<CaseProvider>(context).getCase();
      if(cases != null){
        getData = true;
      }
    });
    return getData == true ? Padding(
      padding: const EdgeInsets.only(top: 14),
      child: SingleChildScrollView(
        child: Column(

          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    StatusContainer(child: Image.asset("assets/blue_dot.png"),),
                    Text("Completed",style: TextStyle(fontSize: 16),),
                  ],
                ),
                Row(
                  children: [
                    StatusContainer(child: Image.asset("assets/green_dot.png"),),
                    Text("In progress",style: TextStyle(fontSize: 16),),
                  ],
                ),

                Row(
                  children: [
                    StatusContainer(child: Image.asset("assets/yellow_dot.png"),),
                    Text("Pending",style: TextStyle(fontSize: 16),),
                  ],
                ),Row(
                  children: [
                    StatusContainer(child: Image.asset("assets/red_dot.png"),),
                    Text("Disposed",style: TextStyle(fontSize: 16),),
                  ],
                ),
              ],

            ),

            SizedBox(height: 20,),

            SingleChildScrollView(
                scrollDirection: Axis.horizontal,child: Card(child: DataInTable2(dateSent: dt,cases: cases,)))

          ],

        ),
      ),
    ) : Container(
        height:300,
        child: Center(child: Text("Error Connecting To NIC Network", style: TextStyle(fontWeight: FontWeight.bold),),));
  }
}


