import 'package:ver2/Components/SplashScreen.dart';
import 'package:ver2/Components/StatusContainer.dart';
import 'package:ver2/Models/DetailScreenArgument.dart';
import 'package:ver2/Models/MyCaseList.dart';
import 'package:ver2/Screens/detailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:ver2/Services/TruncateString.dart';

class DataInTable extends StatefulWidget {
  final String dateSent;
  final int caseId;
  final List<MyCaseList> cases;
  final String officerName;
  final bool dmHere;

  const DataInTable({Key key, this.dateSent, this.caseId,@required this.cases, this.officerName, this.dmHere}) : super(key: key);

  @override
  _DataInTableState createState() => _DataInTableState();
}

class _DataInTableState extends State<DataInTable> {

  @override
  Widget build(BuildContext context) {
    List<MyCaseList> item = [];

    if(widget.caseId == 0 && widget.officerName == null){
      widget.cases.map((items) {

        if(items.hearing_date == widget.dateSent && userLoggedIn == items.assign_to && items.valid == 1){
          item.add(items);
        }
      }).toList();
    }
    else if(widget.officerName != null){
      widget.cases.map((items) {

        if(items.hearing_date == widget.dateSent && items.assign_to == widget.officerName && items.valid == 1){
          item.add(items);
        }
      }).toList();
    }
    else if(widget.dateSent == "none"){
      widget.cases.map((items) {
        if(items.case_id == widget.caseId && userLoggedIn == items.assign_to && items.valid == 1){
          setState(() {
            item.add(items);
          });
        }
      }).toList();
    }

    else{
      widget.cases.map((items) {
        if(items.hearing_date == widget.dateSent && items.case_id == widget.caseId && userLoggedIn == items.assign_to && items.valid == 1){
          setState(() {
            item.add(items);
          });
        }
      }).toList();
    }

    return Container(
      child: Column(
        children: [

          Card(
            child: DataTable(

                showCheckboxColumn: false,
                headingRowColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(167, 208, 251, 1)),
                columns: <DataColumn>[
                  DataColumn(label: Text("Case ID",style: TextStyle(color: Colors.black),)),
                  DataColumn(label: Text("Petionier",style: TextStyle(color: Colors.black),)),
                  DataColumn(label: Text("Respondent",style: TextStyle(color: Colors.black),)),
                ],
                rows: item.map((rowItem) => DataRow(

                    onSelectChanged: (bool selected){
                      if(selected){
                        Navigator.pushNamed(context, DetailsScreen.id,arguments: DetailScreenArgument(
                            caseId: rowItem.case_id,
                            petitioner: rowItem.petitioner,
                            serialNo: rowItem.serial_no,
                            assignTo: rowItem.assign_to,
                            action: rowItem.action,
                            caseType: rowItem.case_type,
                            date: rowItem.date,
                            hearingDate: rowItem.hearing_date,
                            officerRmks: rowItem.officer_rmks,
                            respondent: rowItem.respondent,
                            peshkarRmks: rowItem.peshkarRmks,
                          dmHere: widget.dmHere,
                        ));
                      }
                    },

                    cells: [
                      DataCell(Text(rowItem.case_id.toString())),
                      DataCell(Text(rowItem.petitioner)),
                      DataCell(Text(rowItem.respondent)),

                    ]
                )
                ).toList()
            ),
          ),

          item.isEmpty ? Container(
            padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(12),
              child: Card(child: Text("No Cases for the current selected Date",style: TextStyle(fontWeight: FontWeight.bold),))
          ) : Text("")

        ],
      ),
    );
  }
}


class DataInTable2 extends StatefulWidget {

  final String dateSent;
  final List<MyCaseList> cases;


  const DataInTable2({Key key, this.dateSent,@required this.cases}) : super(key: key);

  @override
  _DataInTable2State createState() => _DataInTable2State();
}

class _DataInTable2State extends State<DataInTable2> {


  @override
  Widget build(BuildContext context) {

    List<MyCaseList> item = [];

    widget.cases.map((items) {
      if(items.hearing_date == widget.dateSent && items.assign_to == userLoggedIn && items.valid == 1){
        item.add(items);
      }
    }).toList();


    return Column(
      children: [

        DataTable(
            showCheckboxColumn: false,
            columnSpacing: 40,
            headingRowColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(167, 208, 251, 1)),
            columns: <DataColumn>[
              DataColumn(label: Text("Case ID",style: TextStyle(color: Colors.black),)),
              DataColumn(label: Text("Petionier",style: TextStyle(color: Colors.black),)),
              DataColumn(label: Text("Respondent",style: TextStyle(color: Colors.black),)),
              DataColumn(label: Text("Status",style: TextStyle(color: Colors.black),)),
            ],
            rows: item.map((rowItem) => DataRow(
                onSelectChanged: (bool selected){
                  if(selected){
                    Navigator.pushNamed(context, DetailsScreen.id,arguments: DetailScreenArgument(
                        caseId: rowItem.case_id,
                        petitioner: rowItem.petitioner,
                        serialNo: rowItem.serial_no,
                        assignTo: rowItem.assign_to,
                        action: rowItem.action,
                        caseType: rowItem.case_type,
                        date: rowItem.date,
                        hearingDate: rowItem.hearing_date,
                        officerRmks: rowItem.officer_rmks,
                        respondent: rowItem.respondent,
                        peshkarRmks: rowItem.peshkarRmks
                    ));
                  }
                },

                cells:
                [

                  DataCell(Text(rowItem.case_id.toString())),
                  DataCell(Text(truncateString(rowItem.petitioner, 7))),
                  DataCell(Text(truncateString(rowItem.respondent, 7))),
                  DataCell(rowItem.action == "Completed" ? StatusContainer(
                    child: Image.asset("assets/blue_dot.png"),)
                      : rowItem.action == "Inprogress" ? StatusContainer(
                    child: Image.asset("assets/green_dot.png"),)
                      : rowItem.action == "Pending" ? StatusContainer(
                    child: Image.asset("assets/yellow_dot.png"),)
                      : StatusContainer(
                      child: Image.asset("assets/red_dot.png")),)
                ]

            )
            ).toList()
        ),

        item.isEmpty ? Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(12),
            child: Card(child: Text("No Cases for the current selected Date",style: TextStyle(fontWeight: FontWeight.bold),))
        ) : Container()

      ],
    );

  }
}