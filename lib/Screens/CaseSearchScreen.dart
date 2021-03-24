import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ver2/Components/DatabaseStuffs/CaseProvider.dart';
import 'package:ver2/Components/DatalnTable.dart';
import 'package:ver2/Components/TextFieldContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ver2/Models/MyCaseList.dart';

class CaseSearchScreen extends StatefulWidget {
  static String id = "CaseSearchScreen";

  @override
  _CaseSearchScreenState createState() => _CaseSearchScreenState();
}

class _CaseSearchScreenState extends State<CaseSearchScreen> {

  List<String> _choice = ['Date', 'Case_No'];
  String _selectedChoice = 'Date';
  String dateNow = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String dateNowSearch = DateFormat('ddMMyyyy').format(DateTime.now());
  DateTime _selectedDate = DateTime.now();
  int tableChange = 0;
  int caseId = 0;
  int caseId1 = 0;
  // ignore: deprecated_member_use
  List<MyCaseList> cases = List<MyCaseList>();

  String text1 = "0";
  String text2 = "0";
  bool getData = false;

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
        dateNowSearch = DateFormat('ddMMyyyy').format(_selectedDate);
        Provider.of<CaseProvider>(context,listen: false).setCaseDateSearch(dateNowSearch);

      });
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CaseProvider>(context,listen: false).setCaseDateSearch(dateNowSearch);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    setState(() {
      cases = Provider.of<CaseProvider>(context).getCaseDateSearch();
      if(cases != null){
        getData = true;
      }
    });


    return getData == true ? SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              _selectedChoice == 'Date' ? Row(
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
                  )

                ],
              ) : Container(
                child: TextFieldContainer(child: TextFormField(
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term){
                    if(text2 == ""){
                      setState(() {
                        caseId1 = 0;
                      });
                    }
                    else{
                      setState(() {
                        caseId1 = int.parse(text2);
                        Provider.of<CaseProvider>(context,listen: false).setCaseID(caseId1.toString());
                        print("enter");
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                    setState(() {
                      text2 = value;
                    });
                  },
                  autofocus: false,

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Case Number",hintStyle: TextStyle(fontSize: 12),
                    icon: GestureDetector(
                        onTap: (){
                          if(text2 == ""){
                            setState(() {
                              caseId1 = 0;
                            });
                          }
                          else{
                            setState(() {
                              caseId1 = int.parse(text2);
                              print("aghsd");
                              Provider.of<CaseProvider>(context,listen: false).setCaseID(caseId1.toString());
                              print("aghsd");

                            });
                          }
                        },
                        child: Icon(Icons.search)
                    ),
                  ),
                )
                ),
              ),

              DropdownButton<String>(
                elevation: 12,
                value: _selectedChoice,
                onChanged: (value){
                  setState(() {
                    _selectedChoice = value;
                  });
                },
                items: _choice.map<DropdownMenuItem<String>>((value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )

            ],
          ),

          SizedBox(height: 20,),

          Center(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _selectedChoice == 'Date' ? DataInTable(dateSent: dateNow,caseId: caseId,cases: cases, dmHere: false,) : DataInTable(dateSent: "none",caseId: caseId1,cases: cases,dmHere: false,)
          )
          ),

        ],
      ),
    ):
    Center(
        child: Container(
        height:100,
        width: 100,
        // child: Center(child: Text("Error Connecting To NIC Network", style: TextStyle(fontWeight: FontWeight.bold),),)
      child: CircularProgressIndicator(),
    )
    );
  }
}

class CaseSearchField extends StatelessWidget {
  const CaseSearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFieldContainer(child: TextField(
        onChanged:(value){
          //code for input changes store
        },
        autofocus: false,

        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Case Number",hintStyle: TextStyle(fontSize: 12),
          icon: GestureDetector(
              onTap: (){
              },
              child: Icon(Icons.search)
          ),
        ),
      )
      ),
    );
  }
}
