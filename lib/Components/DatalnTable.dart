import 'package:provider/provider.dart';
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
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
      print("vashfdsavdasdasd");
      widget.cases.map((items) {

        if(items.hearing_date == widget.dateSent && loggedUserDetail == items.assign_to){
          item.add(items);
        }
      }).toList();
    }
    else if(widget.caseId != 0 && widget.officerName == null){
      print("wow");
      widget.cases.map((items) {

        if(items.hearing_date == widget.dateSent && loggedUserDetail == items.assign_to && widget.caseId == items.case_id){
          item.add(items);
        }
      }).toList();
    }
    else if(widget.dmHere == true && widget.dateSent != null && widget.officerName != null && widget.caseId == 0){
      List<MyCaseList> caseDate = Provider.of<CaseProvider>(context).getCaseDateSearch();
      caseDate == null ? print("wait") :
      caseDate.map((items) {

        if(widget.officerName == items.assign_to){
          item.add(items);
        }
      }).toList();
    }
    else if(widget.dmHere == true && widget.dateSent != null && widget.officerName != null){
      List<MyCaseList> caseDate = Provider.of<CaseProvider>(context).getCaseDateSearch();
      caseDate == null ? print("wait") :
      caseDate.map((items) {

        if(widget.officerName == items.assign_to && widget.caseId == items.case_id){
          item.add(items);
        }
      }).toList();
    }
    else if(widget.dateSent != 'none' && widget.officerName == null){
      List<MyCaseList> caseDate = Provider.of<CaseProvider>(context).getCaseDateSearch();
      caseDate.map((items) {

        if(loggedUserDetail == items.assign_to){
          item.add(items);
        }
      }).toList();
    }
//    else if(widget.officerName != null && widget.caseId != 0){
//      widget.cases.map((items) {
//
//        if(items.hearing_date == widget.dateSent && items.assign_to == widget.officerName && widget.caseId == items.case_id.toInt()){
//          item.add(items);
//        }
//      }).toList();
//    }
    else if(widget.officerName != null){
      List<MyCaseList> officerCase = Provider.of<CaseProvider>(context).getOfficerCase();

      officerCase.map((items) {

        if(items.hearing_date == widget.dateSent && items.assign_to == widget.officerName ){
          item.add(items);
        }
      }).toList();
    }

    else if(widget.dateSent == "none"){
      print("thkhhckasc");
      widget.cases.map((items) {
        if(items.case_id == widget.caseId && loggedUserDetail == items.assign_to){
          setState(() {
            item.add(items);
          });
        }
      }).toList();
    }

    else{
      List<MyCaseList> caseIDSearch = Provider.of<CaseProvider>(context).getCaseID();
      widget.cases.map((items) {
        if(items.hearing_date == widget.dateSent && items.case_id == widget.caseId && loggedUserDetail == items.assign_to || items.valid == 1){//here also changed besuace i dont have valid
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
                  DataColumn(label: Text("Petitioner",style: TextStyle(color: Colors.black),)),
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
                            peshkarRmks: rowItem.peskhar_rmks,
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
      if(items.hearing_date == widget.dateSent && items.assign_to == loggedUserDetail || items.valid == 1){//changed and to or
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
              DataColumn(label: Text("Petitioner",style: TextStyle(color: Colors.black),)),
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
                        peshkarRmks: rowItem.peskhar_rmks
                    ));
                  }
                },

                cells:
                [

                  DataCell(Text(rowItem.case_id.toString())),
                  DataCell(Text(truncateString(rowItem.petitioner, 7))),
                  DataCell(Text(truncateString(rowItem.respondent, 7))),
                  DataCell(rowItem.action == "Inprogress" ? StatusContainer(
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