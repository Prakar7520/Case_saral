import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:ver2/Models/MyCaseList.dart';

import '../Config.dart';

class CaseProvider with ChangeNotifier{

  MyCaseList caseList;
  String errormsg;
  List<MyCaseList> casesAll;
  List<MyCaseList> casesFinalAll;

  List<String> graphDate;

  Future<List<MyCaseList>> fetchCase() async {

    var url = Config.apiUrl;
    var response = await http.get(url);
    List<MyCaseList> cases = [];

    if(response.statusCode == 200){

      for(var note in jsonDecode(response.body)){
        cases.add(MyCaseList.fromJson(note));
      }
    }
    else{
      throw Exception("Failed to Load");
    }
    return cases;

  }






  void setCase()async{
    await fetchCase().then((value) => casesAll = value);
    notifyListeners();
  }

  List<MyCaseList> getCase(){
    return casesAll;
  }

  List<MyCaseList> getTodayCase(){
    List<MyCaseList> todayCase = [];
    casesAll.map((item) {
      if(item.hearing_date == DateFormat('dd/MM/yyyy').format(DateTime.now())){
        todayCase.add(item);
      }

    }).toList();
    return todayCase;
  }

  List<MyCaseList> getCaseDate(String date){

    List<MyCaseList> caseListToday;
    List<MyCaseList> casesAll = getCase();

    casesAll.map((value) {

      if(value.hearing_date == date){
        caseListToday.add(value);
      }

    }).toList();

    return caseListToday;

  }
}