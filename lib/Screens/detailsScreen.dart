import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
import 'package:ver2/Components/Spinner.dart';
import 'package:ver2/Models/DetailScreenArgument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ver2/Models/MyCaseList.dart';
import '../Components/Config.dart';

class DetailsScreen extends StatefulWidget {

  static String id = "DetailsPage";
  bool updated = false;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final c1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final DetailScreenArgument args = ModalRoute.of(context).settings.arguments;

    Future<MyCaseList> updateRemarks(String officer_rmks) async{
      String x = args.serialNo.toString();//assign args.serial_no = x.toString here for testing i used 3
      var url=Config.apiUrl+"/"+x;
      final http.Response response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'officer_rmks': officer_rmks,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 UPDATED response,
        // then parse the JSON.
        setState(() {
          widget.updated = true;
        });
        print("Check updation");
        return MyCaseList.fromJson(jsonDecode(response.body));
      } else {
        print("Could not Update");
        throw Exception('Failed to load album');
      }
    }

    String remarks;
    String displayRmks;
    if(args.officerRmks == null){
      remarks = "No remarks added";
      displayRmks = "No remarks added";
    }
    else{
      print(c1.text);
      remarks = c1.text == "" ? args.officerRmks : c1.text;
    }

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Image.asset("assets/govtofsikkim.png",height: 70,width:70,),
                Text("Govt. Of Sikkim"),
                SizedBox(height: 40,),

                Text("Case Number: ${args.caseId}", style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 10,),
                Text("Serial Number: ${args.serialNo}", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 30,),

                Container(
                  width: size.width *0.9,
                  child: Card(
                    elevation: 4,
                    child: DataTable(
                        headingRowHeight: 0,
                        columns: <DataColumn>[
                          DataColumn(label: Text("")),
                          DataColumn(label: Text(""))
                        ],
                        rows: <DataRow>[
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Date")),
                                DataCell(Text("${args.date}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Petionier")),
                                DataCell(Text("${args.petitioner}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Respondent")),
                                DataCell(Text("${args.respondent}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Type")),
                                DataCell(Text("${args.caseType}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Assigned To")),
                                DataCell(Text("${args.assignTo}")),
                              ]
                          ),

                        ]
                    ),
                  ),
                ),

                Container(
                  width: size.width *0.9,
                  child: Card(
                    elevation: 4,
                    child: DataTable(
                        headingRowHeight: 0,
                        columns: <DataColumn>[
                          DataColumn(label: Text("")),
                          DataColumn(label: Text(""))
                        ],
                        rows: <DataRow>[
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Hearing Date")),
                                DataCell(Text("${args.hearingDate}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Status")),
                                DataCell(Text("${args.action}")),
                              ]
                          ),
                        ]
                    ),
                  ),
                ),

                SizedBox(height: 18,),

                Container(
                  height: 60,
                  child: Card(
                    elevation: 4,
                      child: Center(child: Text(remarks,style: TextStyle(fontSize: 20),))
                  ),
                ),

                widget.updated == true ? Text("Remarks after change : Updated",style: TextStyle(color: Colors.green),) : Text("Remarks Un-edited",style: TextStyle(color: Colors.red),),


                SizedBox(height: 20,),
                args.dmHere == false ? Container(
                  decoration: BoxDecoration(
                      color: Colors.cyan[200],
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: FlatButton.icon(
                      color: Colors.cyan[200],
                      onPressed: (){
                        showModalBottomSheet(
                            context: context, builder: (context) => Container(

                          color: Color(0xff757575),
                          child: Container(
                            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "add remarks",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, right: 15, bottom: 10),
                                    child: TextFormField(
                                      controller: c1,
                                      decoration: InputDecoration(border: InputBorder.none),
                                      autofocus: true,
                                      maxLines: 5,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: FlatButton.icon(
                                      color: Colors.grey[200],
                                      onPressed: () {
                                        setState(() {
                                          remarks = c1.text;
                                          updateRemarks(remarks);
                                        });
                                        Provider.of<CaseProvider>(context,listen: false).setCase();
                                        Provider.of<CaseProvider>(context,listen: false).setCase();
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.done),
                                      label: Text("Submit")),
                                ),
                              ],
                            ),
                          ),
                        ));
                      },
                      icon: Icon(Icons.edit),
                      label: Text("Remarks"),
                  ),
                ) : Container(),


              ],
            ),
          ),
        ),
      ),
    );
  }
  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('on Updation'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),

            ],
          );
        });
  }

  void _popupDialogFail(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Fail'),
            content: Text('on Updation'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),

            ],
          );
        });
  }
}
