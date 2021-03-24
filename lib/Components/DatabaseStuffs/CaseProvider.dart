import 'dart:convert';
import 'package:flutter/material.dart';
import '../../Services/Storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ver2/Components/SplashScreen.dart';
import 'package:ver2/Models/MyCaseList.dart';
import 'package:ver2/Models/UserModel.dart';
import 'package:ver2/Services/Storage.dart';

class CaseProvider with ChangeNotifier{

  MyCaseList caseList;
  String errormsg;
  List<MyCaseList> casesAll;
  List<MyCaseList> casesAllDateSearch;
  List<MyCaseList> casesFinalAll;
  List<MyCaseList> officerCasesAll;
  List<MyCaseList> caseDateAssign;
  List<MyCaseList> casesIDSearch;
  List<UserModel> user;
  String firstname;

  var sss = SecureStorage();
  var url;
  var token;

  Future<List<MyCaseList>> fetchCase() async {
    token= await sss.readSecureData('token');
    url = 'http://10.182.65.28/caseassign/${loggedUserDetail}';
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },);
    List<MyCaseList> cases = [];

    if(response.statusCode == 200){

      for(var note in jsonDecode(response.body)){
        cases.add(MyCaseList.fromJson(note));
      }
    }
    else{
      throw Exception("Failed to Load");
    }
    notifyListeners();
    return cases;

  }

  Future<List<MyCaseList>> fetchCaseDateSearch(String date) async {
    token= await sss.readSecureData('token');
    print(token);
    url ="http://10.182.65.28/casedate/$date";
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },);
    List<MyCaseList> cases = [];

    if(response.statusCode == 200){

      for(var note in jsonDecode(response.body)){
        cases.add(MyCaseList.fromJson(note));
      }
    }
    else{
      throw Exception("Failed to Load");
    }
    notifyListeners();
    return cases;

  }

  Future<List<MyCaseList>> fetchOfficerCase(String officerName) async {
    token= await sss.readSecureData('token');
    url = 'http://10.182.65.28/caseassign/${officerName}';
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },);
    List<MyCaseList> cases = [];

    if(response.statusCode == 200){

      for(var note in jsonDecode(response.body)){
        cases.add(MyCaseList.fromJson(note));
      }
    }
    else{
      throw Exception("Failed to Load");
    }
    notifyListeners();
    return cases;

  }

  Future<List<MyCaseList>> fetchCaseID(String caseID) async {
    print("CASEIDSEARCH");
    token= await sss.readSecureData('token');
    print(caseID);
    url = 'http://10.182.65.28/caseid/${caseID}';
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },);
    List<MyCaseList> cases = [];

    if(response.statusCode == 200){

      for(var note in jsonDecode(response.body)){
        cases.add(MyCaseList.fromJson(note));
      }
    }
    else{
      throw Exception("Failed to Load");
    }
    notifyListeners();
    return cases;

  }
  void setCaseID(String caseID)async {
    await fetchCaseID(caseID).then((value) {
      casesIDSearch = value;
      print(value.length);
    });
//    notifyListeners();
  }
  List<MyCaseList> getCaseID() {
    return casesIDSearch;
  }

  Future<List<MyCaseList>> fetchDateAssign(String date,String assign) async {
    token= await sss.readSecureData('token');
    url = 'http://10.182.65.28/casedat/${date}/${assign}';
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },);
    List<MyCaseList> cases = [];

    if(response.statusCode == 200){

      for(var note in jsonDecode(response.body)){
        cases.add(MyCaseList.fromJson(note));
      }
    }
    else{
      throw Exception("Failed to Load");
    }
    notifyListeners();
    return cases;

  }
  void setDateAssign(String date,String assign)async {
    await fetchDateAssign(date,assign).then((value) => caseDateAssign = value);
//    notifyListeners();
  }
  List<MyCaseList> getDateAssign() {
    return caseDateAssign;
  }








  void setOfficerCase(String officerName)async {
    await fetchOfficerCase(officerName).then((value) => officerCasesAll = value);
//    notifyListeners();
  }
  List<MyCaseList> getOfficerCase() {
    return officerCasesAll;
  }







  void setCase()async {
    await fetchCase().then((value) => casesAll = value);

    notifyListeners();
  }
  List<MyCaseList> getCase(){
    return casesAll;
  }



  void setCaseDateSearch(String date)async {
    await fetchCaseDateSearch(date).then((value) => casesAllDateSearch = value);
    // notifyListeners();
  }
  List<MyCaseList> getCaseDateSearch() {
    return casesAllDateSearch;
  }


  String loggedInUsername(){
    if(user == null){
      firstname = userLoggedIn;
    }
    else{
      user.map((value) {
        if(userLoggedIn == value.username){
          firstname = value.firstname;
        }
      }).toList();
    }

    return firstname;
  }

}