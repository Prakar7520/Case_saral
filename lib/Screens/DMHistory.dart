import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
import 'package:ver2/Components/DatalnTable.dart';
import 'package:ver2/Models/MyCaseList.dart';

class DMHistory extends StatefulWidget {
  static String id = "DMHistory";

  @override
  _DMHistoryState createState() => _DMHistoryState();
}

class _DMHistoryState extends State<DMHistory> {

  List<String> _choice = ['ADC(E)','ADC(HQ)','SDM(E)','SDM(HQ)'];
  String _selectedChoice = 'ADC(E)';
  String officerName = "ADC(E)";
  String dateNow = DateFormat('dd/MM/yyyy').format(DateTime.now());
  DateTime _selectedDate = DateTime.now();
  int tableChange = 0;
  int caseId = 0;
  int caseId1 = 0;
  List<MyCaseList> cases = List<MyCaseList>();

  String text1 = "";

  void _presentDataPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        dateNow = DateFormat('dd/MM/yyyy').format(_selectedDate);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool getData = false;
    setState(() {
      cases = Provider.of<CaseProvider>(context).getCase();
      if(cases != null){
        getData = true;
      }
    });
    return Scaffold(

      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                        height: 50,
                        width: size.width*0.47,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value){
                            setState(() {
                              text1 = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Case_No. or use Date->",hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900
                          ),
                            icon: GestureDetector(
                                onTap: (){
                                  print("tapped");
                                  if(text1 == ""){
                                    setState(() {
                                      caseId = 0;
                                    });
                                  }
                                  else{
                                    setState(() {
                                      caseId = int.parse(text1);
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.search),
                                )
                            ),
                          ),
                        )
                    ),

                    Container(
                      height: 50,
                      width: size.width*0.14,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topRight: Radius.circular(12),bottomRight: Radius.circular(12))
                      ),
                      child: FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Icon(Icons.date_range,size: 25,color: Colors.grey[600],),
                        onPressed:_presentDataPicker,
                      ),
                    ),


                  ],
                ),
                SizedBox(height: 3,),
                Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                  ),

                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      elevation: 12,
                      value: _selectedChoice,
                      onChanged: (value){
                        setState(() {
                          _selectedChoice = value;
                          officerName = _selectedChoice;
                        });
                      },
                      items: _choice.map<DropdownMenuItem<String>>((value){
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                Center(child: getData == true ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataInTable(dateSent: dateNow,caseId: caseId,cases: cases,officerName: officerName,dmHere: true,)
                ):Container(
                    height:size.height *0.8,
                    child: Center(child: Text("Error Connecting To NIC Network", style: TextStyle(fontWeight: FontWeight.bold),),)),
                )
              ],
            ),
          )
        ),
      ),

    );
  }
}
